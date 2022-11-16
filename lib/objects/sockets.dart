import 'dart:io';

class NamedSocket {
  String id;
  Socket socket;

  NamedSocket({required this.id, required this.socket});
}

class NamedSocketList {
  List<NamedSocket> namedSocketList;

  NamedSocketList({required this.namedSocketList});

  NamedSocket findById(String id) {
    return namedSocketList.firstWhere((namedSocket) => namedSocket.id == id);
  }

  void addNamedSockets(List<NamedSocket> namedSocketList) {
    for (NamedSocket namedSocket in namedSocketList) {
      this.namedSocketList.add(namedSocket);
    }
  }
}
