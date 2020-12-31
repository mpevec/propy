import { Injectable } from '@angular/core';
import { ActivatedRouteSnapshot, CanActivate, RouterStateSnapshot } from '@angular/router';
import { Observable, of } from 'rxjs';
import { map, take, switchMap } from 'rxjs/operators';
import { User } from 'src/app/shared/models/index';
import { CoreFacade } from './core.facade';

@Injectable({
  providedIn: 'root',
})
export class AuthGuard implements CanActivate {

  constructor(private coreFacade: CoreFacade) {}

  canActivate(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): Observable<boolean> {
    return this.coreFacade.loggedUser$.pipe(
      take(1),
      switchMap((user: User | null) => {
        if (!user) {
          this.coreFacade.refreshToken();

          return this.coreFacade.userOnlyAfterRefreshToken$.pipe(
            map((refreshedUser: User | null) => {
              if (!refreshedUser) {
                this.coreFacade.redirectToLogin();
                return false;
              }
              return true;
            }),
            take(1),
          );

        }
        return of(true);
      }),
    );
  }
}
