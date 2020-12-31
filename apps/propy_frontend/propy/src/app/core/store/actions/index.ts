import { createAction, props } from '@ngrx/store';

export const login = createAction('[Login Page] Login', props<{ username: string, password: string }>());
export const loginSuccess = createAction('[Login API] Login Success', props<{ jwt: string }>());
export const loginError = createAction('[Login API] Login Error', props<{ error: any }>());
export const refreshToken = createAction('[Login Page] Refresh Token');
export const refreshTokenSuccess = createAction('[Login API] Refresh Token Success', props<{ jwt: string }>());
export const refreshTokenError = createAction('[Login Page] Refresh Token Error');
export const redirect = createAction('[Auth Guard] Redirect to login');
