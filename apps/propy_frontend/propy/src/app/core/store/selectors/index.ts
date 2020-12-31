import { createSelector } from '@ngrx/store';
import * as fromRootReducer from '../../../store/reducers/index';
import * as fromReducer from '../reducers/index';

export const getLogging = createSelector(fromRootReducer.getCore, fromReducer.getLogging);
export const getLoggedUser = createSelector(fromRootReducer.getCore, fromReducer.getLoggedUser);
export const getLoggingError = createSelector(fromRootReducer.getCore, fromReducer.getLoggingError);
export const getJwt = createSelector(fromRootReducer.getCore, fromReducer.getJwt);
export const getRefreshedTokenAt = createSelector(fromRootReducer.getCore, fromReducer.getRefreshedTokenAt);
