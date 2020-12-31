import { InjectionToken } from '@angular/core';
import { Action, ActionReducerMap, MetaReducer } from '@ngrx/store';
import { environment } from 'src/environments/environment';
import * as fromCore from '../../core/store/reducers/index';

export function logger(reducerFunc: any): any {
  return (state: any, action: any) => {
    const result = reducerFunc(state, action);
    console.groupCollapsed(action.type);
    console.log('prev state', state);
    console.log('action', action);
    console.log('next state', result);
    console.groupEnd();

    return result;
  };
}

export const REDUCER_TOKEN = new InjectionToken<ActionReducerMap<State, Action>>(
  'Root reducers token',
  { factory: () => reducers },
);

export const metaReducers: MetaReducer<State>[] = !environment.production ? [logger] : [];

export interface State {
  core: fromCore.State;
}

const reducers = {
  core: fromCore.reducer,
};

export const getCore = (state: State) => state.core;


