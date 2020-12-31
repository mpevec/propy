import { HttpErrorResponse } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { Actions, ofType, createEffect } from '@ngrx/effects';
import { Action } from '@ngrx/store';
import { of } from 'rxjs';
import { catchError, switchMap, map, tap } from 'rxjs/operators';
import { AuthService } from '../../services/auth.service';
import * as fromActions from '../actions/index';

@Injectable()
export class AuthEffects {

  login$ = createEffect(() => {
    return this.actions$.pipe(
      ofType(fromActions.login),
      switchMap(({ username, password }) => {
        return this.authService.login(username, password).pipe(
          map((jwtResponse: { jwt: string }) => {
            return fromActions.loginSuccess({ jwt: jwtResponse.jwt });
          }),
          catchError((error: HttpErrorResponse) => {
            if (error.status === 401) {
              return of(this.errorLoginAction('Unknown user.'));
            }
            return of(this.errorLoginAction('Error loging in.'));
          }),
        );
      })
    );
  });

  refreshToken$ = createEffect(() => {
    return this.actions$.pipe(
      ofType(fromActions.refreshToken),
      switchMap(() => {
        return this.authService.refreshToken().pipe(
          map((jwtResponse: any) => {
            return fromActions.refreshTokenSuccess({ jwt: jwtResponse.jwt });
          }),
          catchError((error: HttpErrorResponse) => {
            return of(fromActions.refreshTokenError());
          }),
        );
      })
    );
  });

  loginError$ = createEffect(
    () =>
      this.actions$.pipe(
        ofType(fromActions.loginError, fromActions.refreshTokenError),
        map((action: any) => action.error),
        tap((error: any) => console.log('Error communicating with BEND:', error))
      ),
    { dispatch: false }
  );

  loginSuccess$ = createEffect(
    () =>
      this.actions$.pipe(
        ofType(fromActions.loginSuccess),
        tap(() => this.router.navigate(['/dashboard']))
      ),
    { dispatch: false }
  );

  loginRedirect$ = createEffect(
    () =>
      this.actions$.pipe(
        ofType(fromActions.redirect),
        tap(() => {
          this.router.navigate(['/login']);
        })
      ),
    { dispatch: false }
  );

  constructor(private actions$: Actions, private authService: AuthService, private router: Router) {}

  private errorLoginAction(msg: string): Action {
    return fromActions.loginError({ error: 'Unknown user.' });
  }
}
