import { Injectable } from '@angular/core';
import { HttpRequest, HttpHandler, HttpEvent, HttpInterceptor } from '@angular/common/http';
import { Observable } from 'rxjs';
import { take, switchMap } from 'rxjs/operators';
import { CoreFacade } from './core.facade';

@Injectable()
export class JwtInterceptor implements HttpInterceptor {
    constructor(private coreFacade: CoreFacade) { }

    intercept(request: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
      return this.coreFacade.jwt$.pipe(
        // we take(1) and hence close subscription, otherwise we would have another event right a way after
        // the jwt is put in the store (after first login request) which then triggers this pipe again
        take(1),
        switchMap((jwt: string | null) => {
          if (!jwt || this.isResourcePublic(request.url)) {
            return next.handle(request);
          }
          request = request.clone({
            setHeaders: {
                Authorization: `Bearer ${jwt}`
            }
          });
          return next.handle(request);
        }),
      );
    }

    private isResourcePublic(url: string | null): boolean {
      return !!url && url.includes('/login');
    }
}
