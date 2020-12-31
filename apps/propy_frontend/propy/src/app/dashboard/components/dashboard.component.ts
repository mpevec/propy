import { Component, EventEmitter, Input, Output } from '@angular/core';
import { AuthService } from 'src/app/core/services/auth.service';
import { User } from 'src/app/shared/models/index';

@Component({
  selector: 'app-dashboard-ui',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.scss']
})
export class DashboardComponent {
  @Input() user?: User;

  constructor(private authService: AuthService) {
  }

  public test($event: any): void {
    this.authService.test().subscribe(() => {

    });
  }
}
