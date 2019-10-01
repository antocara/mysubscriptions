class Renewal {
  Renewal({this.id, this.subscriptionId, this.renewalAt});

  int id;
  int subscriptionId;
  DateTime renewalAt;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subscriptionId': subscriptionId,
      'renewalAt': renewalAt,
    };
  }

  static Renewal fromMap(Map<String, dynamic> map) {
    return Renewal(
      id: map['id'],
      subscriptionId: map['subscription_id'],
      renewalAt: map['renewal_at'],
    );
  }
}
