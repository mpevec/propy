import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { LoginContainerComponent } from './core/components/login/login.container';
import { AuthGuard } from './core/services/auth.guard';

const routes: Routes = [
  { path: '', redirectTo: '/dashboard', pathMatch: 'full' },
  { path: 'login', component: LoginContainerComponent },
  {
    path: 'dashboard',
    loadChildren: () => {
      return import('./dashboard/dashboard.module').then((m) => m.DashboardModule);
    },
    canActivate: [AuthGuard],
  },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
