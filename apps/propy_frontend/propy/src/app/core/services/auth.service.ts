import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable, of } from 'rxjs';
import { catchError, delay, map } from 'rxjs/operators';
import { environment } from '../../../environments/environment';

@Injectable({ providedIn: 'root' })
export class AuthService {

  constructor(private httpClient: HttpClient) {
  }

  public test(): Observable<any> {
    const url = `${environment.baseUrl}/api/greetings`;
    return this.httpClient.get(url);
  }

  public refreshToken(): Observable<{ jwt: string }> {
    const url = `${environment.baseUrl}/api/login/refresh_token`;
    // to pass cookie + CORS we need withCredentials: true
    return this.httpClient.get<{ jwt: string }>(url, { withCredentials: true });
  }

  public login(username: string, password: string): Observable<{ jwt: string }> {
    const url = `${environment.baseUrl}/api/login`;
    const message = {
      username,
      password,
    };
    return this.httpClient.post<{ jwt: string }>(url, message);
  }
}

