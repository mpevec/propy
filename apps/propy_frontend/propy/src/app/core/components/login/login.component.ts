import { Component, EventEmitter, Input, Output } from '@angular/core';
import { FormControl, FormGroup } from '@angular/forms';
import { LoginForm } from './login-form.model';

@Component({
  selector: 'app-login-ui',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent {
  @Input() logging?: boolean;
  @Input() error?: string;
  @Output() login: EventEmitter<LoginForm> = new EventEmitter<LoginForm>();

  public form: FormGroup;

  constructor() {
    this.form = new FormGroup({
      username: new FormControl('janez.novak@hey.com'),
      password: new FormControl('abc123'),
    });
  }

  public doLogin($event: any): void {
    this.login.emit(this.getFormValue());
  }

  private getFormValue(): LoginForm {
    return {
      username: this.form.get('username')?.value,
      password: this.form.get('password')?.value,
    };
  }
}
