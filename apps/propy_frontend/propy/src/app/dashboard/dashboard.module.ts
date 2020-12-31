import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { DashboardContainerComponent } from './components/dashboard.container';
import { DashboardRoutingModule } from './dashboard-routing.module';
import { SharedModule } from '../shared/shared.module';
import { CoreModule } from '../core/core.module';
import { DashboardComponent } from './components/dashboard.component';

export const COMPONENTS = [
  DashboardContainerComponent,
  DashboardComponent,
];

@NgModule({
  declarations: COMPONENTS,
  imports: [
    CommonModule,
    SharedModule,
    CoreModule, // we need user info
    DashboardRoutingModule,
  ],
  providers: [
  ],
  exports: COMPONENTS,
})
export class DashboardModule { }
