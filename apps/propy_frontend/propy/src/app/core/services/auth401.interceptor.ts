import { Injectable } from '@angular/core';
import { HttpRequest, HttpHandler, HttpEvent, HttpInterceptor, HttpErrorResponse } from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { catchError } from 'rxjs/operators';
import { Router } from '@angular/router';

@Injectable()
export class Auth401Interceptor implements HttpInterceptor {
    constructor(private router: Router) { }

    intercept(request: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
      return next.handle(request).pipe(
        catchError((error: HttpErrorResponse) => {
          if (this.responseIsNotAuthorized(error) && !this.isResourcePublic(error.url)) {
            this.router.navigate(['/login']);
          }
          return throwError(error);
        }),
      );
    }

    private responseIsNotAuthorized(error: HttpErrorResponse): boolean {
      return error.status === 401;
    }

    private isResourcePublic(url: string | null): boolean {
      return !!url && url.includes('/login');
    }
}
