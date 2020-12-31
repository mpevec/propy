
import { Component } from '@angular/core';
import { Observable } from 'rxjs';
import { AuthService } from 'src/app/core/services/auth.service';
import { CoreFacade } from 'src/app/core/services/core.facade';
import { User } from 'src/app/shared/models/index';

@Component({
  selector: 'app-dashboard',
  template: '<app-dashboard-ui [user]="(user$ | async)!"></app-dashboard-ui> '
})
export class DashboardContainerComponent {
  public user$: Observable<User | null>;

  constructor(private coreFacade: CoreFacade, private authService: AuthService) {
    this.user$ = this.coreFacade.loggedUser$;
  }
}
