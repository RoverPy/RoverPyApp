class DevInfo {
  final String name;
  final String gitLink;
  final String imageLink;
  final String otherInfo;
  final Details deets;

  DevInfo({this.name, this.gitLink, this.imageLink, this.otherInfo, this.deets});
}

List<DevInfo> developers = [
  DevInfo(name: 'Miheer', imageLink: 'https://avatars2.githubusercontent.com/u/64085060?s=88&v=4', otherInfo: 'very USEFUL member of our team'),
  DevInfo(name: 'Pratit', gitLink: 'https://github.com/Pratit23', imageLink: 'https://avatars0.githubusercontent.com/u/51255935?s=88&u=e927222c63aca671a6ef6687b7f271372df975c1&v=4', otherInfo: 'an actually useful member of the team'),
  DevInfo(name: 'Aajinkya', gitLink: 'https://github.com/aajinkya1203', imageLink: 'https://avatars1.githubusercontent.com/u/43881544?s=460&u=3be59f8159d8a48db196bc3b10b5d66c0faf84d0&v=4', otherInfo: 'another actually useful member of the team'),
  DevInfo(name: 'Aditi', gitLink: 'https://github.com/Aditi-Mohan', imageLink: 'https://avatars2.githubusercontent.com/u/54301942?s=88&v=4', otherInfo: 'who cares'),
];

class Details {

}