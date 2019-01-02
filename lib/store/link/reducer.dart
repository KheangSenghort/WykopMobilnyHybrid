import 'package:redux/redux.dart';
import 'package:owmflutter/store/store.dart';

LinkScreensState linkScreenReducer(LinkScreensState state, action) {
  if (action is TypedAction && action.type.startsWith(LINK_PREFIX)) {
    var id = action.type.split('_')[1];
    var newState = state
        .rebuild((b) => b..states.putIfAbsent(id, () => LinkScreenState()));
    return newState.rebuild((e) => e
      ..states.updateValue(
          id,
          (linkScreenState) => linkScreenState.rebuild(
                (k) => k
                  ..replace(_linkScreenReducer(newState.states[id], action))
                  ..errorState.replace(createErrorReducer(
                      newState.states[id].errorState,  LINK_PREFIX + id, action)),
              )));
  } else {
    return state;
  }
}

Reducer<LinkScreenState> _linkScreenReducer = combineReducers([
  TypedReducer<LinkScreenState, SetLinkComments>(_setLinkComments),
]);

LinkScreenState _setLinkComments(LinkScreenState state, SetLinkComments action) {
  return state.rebuild((b) => b
    ..ids.clear()
    ..ids.addAll(action.ids));
}
