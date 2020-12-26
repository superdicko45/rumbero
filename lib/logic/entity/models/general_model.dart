class General {
  int itemId;
  String item;

  General({this.itemId, this.item});

  General.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
    item = json['item'];
  }
}
