class MessageModel {
  String? formId;
  String? type;
  String? msg;
  String? read;
  String? told;
  String? sent;

  MessageModel(
      {this.formId, this.msg, this.read, this.told, this.sent, this.type});

  MessageModel.fromJson(Map<String, dynamic> json) {
    formId = json['formId'];
    type = json['type'];
    msg = json['msg'];
    read = json['read'];
    told = json['told'];
    sent = json['sent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['formId'] = this.formId;
    data['type'] = this.type;
    data['msg'] = this.msg;
    data['read'] = this.read;
    data['told'] = this.told;
    data['sent'] = this.sent;
    return data;
  }
}
