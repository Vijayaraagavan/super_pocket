class StorageItem {
  final String username;
  final String password;
  String website = '';
  String id = '';

  StorageItem(this.username, this.password, this.website);

  StorageItem.update(this.id, this.username, this.password, this.website);

  @override
  String toString() {
    return 'user: ${username}, pass: ${password}}, web: ${website} for id: ${id}';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'password': password,
        'website': website
      };
}
