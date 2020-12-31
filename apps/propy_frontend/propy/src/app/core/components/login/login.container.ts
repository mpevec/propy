
import { Component } from '@angular/core';
import { Observable } from 'rxjs';
import { CoreFacade } from '../../services/core.facade';
import { LoginForm } from './login-form.model';

@Component({
  selector: 'app-login',
  template: `<app-login-ui [logging]="(logging$ | async)!"
                           [error]="(error$ | async)!"
                           (login)="onLogin($event)">
            </app-login-ui>`
})
export class LoginContainerComponent {
  public logging$: Observable<boolean>;
  public error$: Observable<string>;

  constructor(private coreFacade: CoreFacade) {
    this.logging$ = this.coreFacade.logging$;
    this.error$ = this.coreFacade.loggingError$;
  }

  public onLogin({ username, password }: LoginForm): void {
    this.coreFacade.login(username, password);
  }
}
