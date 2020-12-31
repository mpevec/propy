import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ButtonSpinnerDirective } from './directives/button-spinner.directive';

export const COMPONENTS = [
  ButtonSpinnerDirective,
];

@NgModule({
  declarations: COMPONENTS,
  imports: [
    CommonModule,
  ],
  providers: [
  ],
  exports: COMPONENTS,
})
export class SharedModule { }
