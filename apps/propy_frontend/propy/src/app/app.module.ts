import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { StoreModule } from '@ngrx/store';
import { REDUCER_TOKEN, metaReducers } from './store/reducers/index';
import { StoreDevtoolsModule } from '@ngrx/store-devtools';
import { environment } from 'src/environments/environment';
import { CoreModule } from './core/core.module';
import { EffectsModule } from '@ngrx/effects';
import { AuthEffects } from './core/store/effects';
import { SharedModule } from './shared/shared.module';
import { HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http';
import { JwtInterceptor } from './core/services/jwt.interceptor';
import { Auth401Interceptor } from './core/services/auth401.interceptor';

@NgModule({
  declarations: [
    AppComponent,
  ],
  imports: [
    BrowserModule,
    HttpClientModule,
    CommonModule,
    AppRoutingModule,
    CoreModule,
    SharedModule,
    StoreDevtoolsModule.instrument({  name: 'NgRx Propy' }),
    StoreModule.forRoot(REDUCER_TOKEN, { metaReducers }),
    EffectsModule.forRoot([AuthEffects]),
  ],
  providers: [
      { provide: HTTP_INTERCEPTORS, useClass: JwtInterceptor, multi: true },
      { provide: HTTP_INTERCEPTORS, useClass: Auth401Interceptor, multi: true },
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
