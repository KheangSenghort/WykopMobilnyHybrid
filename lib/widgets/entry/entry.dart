import 'package:flutter/material.dart';
import 'package:owmflutter/models/models.dart';
import 'package:owmflutter/widgets/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:owmflutter/store/store.dart';

class EntryWidget extends StatelessWidget {
  final int entryId;
  final bool ellipsize;
  final bool isClickable;
  EntryWidget({
    this.entryId,
    this.ellipsize,
    this.isClickable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: Key(entryId.toString()),
      padding: EdgeInsets.only(
        bottom: 0.0,
      ),
      child: Material(
        color: Theme.of(context).cardColor,
        child: StoreConnector<AppState, Entry>(
          converter: (store) => store.state.entitiesState.entries[entryId],
          builder: (context, entry) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      AuthorWidget(
                        author: entry.author,
                        date: entry.date,
                        fontSize: 14.0,
                        padding:
                            EdgeInsets.only(top: 12.0, bottom: 0.0, right: 4.0),
                      ),
                      _drawVoteButton(entry),
                    ],
                  ),
                  _drawBody(entry),
                  _drawEmbed(entry),
                  EntryFooterWidget(entry, this.isClickable),
                  Divider(height: 1.0,),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _drawVoteButton(Entry entry) {
    return Padding(
      padding: EdgeInsets.only(
        right: 0.0,
      ),
      child: StoreConnector<AppState, VoidCallback>(
        converter: (state) => () => state.dispatch(voteEntry(entryId)),
        builder: (context, callback) => VoteButton(
              isSelected: entry.isVoted,
              count: entry.voteCount,
              onClicked: () {
                callback();
              },
            ),
      ),
    );
  }

  Widget _drawBody(Entry entry) {
    if (entry.body != null) {
      return BodyWidget(
        body: entry.body,
        ellipsize: ellipsize,
        padding: EdgeInsets.only(
          top: 12.0,
          left: 2.0,
          right: 2.0,
          bottom: 2.0,
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _drawEmbed(Entry entry) {
    if (entry.embed != null) {
      return Container(
        padding: EdgeInsets.only(top: 14.0, bottom: 2.0),
        child: EmbedWidget(
          embed: entry.embed,
          borderRadius: 14.0,
          reducedWidth: 36.0,
        ),
      );
    } else {
      return Container();
    }
  }
}
