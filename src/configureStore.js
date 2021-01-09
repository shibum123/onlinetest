import { combineReducers, createStore } from 'redux';
import mainReducer from './reducers/mainReducer';

const reducer = combineReducers({
  main: mainReducer
});

const store = createStore(reducer);

export default store;
