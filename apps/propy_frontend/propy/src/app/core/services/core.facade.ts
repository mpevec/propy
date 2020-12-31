import { Injectable } from '@angular/core';
import { Store } from '@ngrx/store';
import * as fromSelectors from '../store/selectors/index';
import * as fromActions from '../store/actions/index';
import { filter, switchMap } from 'rxjs/operators';

@Injectable({ providedIn: 'root' })
export class CoreFacade {
  public logging$ = this.store.select(fromSelectors.getLogging);
  public loggedUser$ = this.store.select(fromSelectors.getLoggedUser);
  public loggingError$ = this.store.select(fromSelectors.getLoggingError);
  public jwt$ = this.store.select(fromSelectors.getJwt);
  public userOnlyAfterRefreshToken$ = this.store.select(fromSelectors.getRefreshedTokenAt).pipe(
    filter(t => !!t),
    switchMap(() => {
      return this.store.select(fromSelectors.getLoggedUser);
    }),
  );

  constructor(private store: Store<any>) {
  }

  public login(username: string, password: string): void {
    this.store.dispatch(fromActions.login({ username, password }));
  }

  public refreshToken(): void {
    this.store.dispatch(fromActions.refreshToken());
  }

  public redirectToLogin(): void {
    this.store.dispatch(fromActions.redirect());
  }
}

