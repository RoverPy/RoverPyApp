class DevInfo {
  final String name;
  final String gitLink;
  final String imageLink;
  final String otherInfo;
  final Details deets;

  DevInfo(
      {this.name, this.gitLink, this.imageLink, this.otherInfo, this.deets});
}

List<DevInfo> developers = [
  DevInfo(
      name: 'Miheer',
      gitLink: 'https://github.com/mimi69-38',
      imageLink: 'assets/Miheer.png',
      otherInfo: 'very USEFUL member of our team'),
  DevInfo(
      name: 'Pratit',
      gitLink: 'https://github.com/Pratit23',
      imageLink: 'assets/Pratit.png',
      otherInfo: 'an actually useful member of the team'),
  DevInfo(
      name: 'Aajinkya',
      gitLink: 'https://github.com/aajinkya1203',
      imageLink: 'assets/Aajinkya.jpg',
      otherInfo: 'another actually useful member of the team'),
  DevInfo(
      name: 'Aditi',
      gitLink: 'https://github.com/Aditi-Mohan',
      imageLink: 'assets/Aditi.png',
      otherInfo: 'we do bruh. about jiggy too!'),
];

class Details {}
