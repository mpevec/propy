import { createReducer, on } from '@ngrx/store';
import { toUser, User } from 'src/app/shared/models/index';
import * as fromActions from '../actions/index';

export interface State {
  logging: boolean;
  loggingError: any;
  loggedUser: User | null;
  jwt: string | null ;
  refreshedTokenAt: number | null;
}

const initialState: State = {
  logging: false,
  loggingError: null,
  loggedUser: null,
  jwt: null,
  refreshedTokenAt: null,
};

export const reducer = createReducer(
  initialState,
  on(fromActions.login, (state) => ({
    ...state,
    logging: true,
    loggingError: null,
  })),
  on(fromActions.loginSuccess, (state, { jwt }) => {
    const loggedUser = toUser({ jwt });
    return {
      ...state,
      logging: false,
      loggedUser,
      jwt,
    };
  }),
  on(fromActions.refreshTokenSuccess, (state, { jwt }) => {
    const loggedUser = toUser({ jwt });
    return {
      ...state,
      loggedUser,
      jwt,
      refreshedTokenAt: (new Date()).getTime(),
    };
  }),
  on(fromActions.refreshTokenError, (state) => ({
    ...state,
    refreshedTokenAt: (new Date()).getTime(),
  })),
  on(fromActions.loginError, (state, { error }) => ({
    ...state,
    logging: false,
    loggingError: error
  })),
);

export const getLogging = (state: State) => state.logging;
export const getLoggingError = (state: State) => state.loggingError;
export const getLoggedUser = (state: State) => state.loggedUser;
export const getJwt = (state: State) => state.jwt;
export const getRefreshedTokenAt = (state: State) => state.refreshedTokenAt;
