import 'package:pulsar/classes/interest.dart';
import 'package:pulsar/classes/media.dart';

Interest acting = Interest(
    name: 'Acting',
    category: 'Actor',
    coverPhoto: Photo(thumbnail: 'assets/categories/actor.jpg'));

Interest art = Interest(
    name: 'Art',
    category: 'Artist',
    coverPhoto: Photo(thumbnail: 'assets/categories/artist.jpg'));

Interest comedy = Interest(
    name: 'Comedy',
    category: 'Comedian',
    coverPhoto: Photo(thumbnail: 'assets/categories/comedian.jpg'));

Interest dance = Interest(
    name: 'Dance',
    category: 'Dancer',
    coverPhoto: Photo(thumbnail: 'assets/categories/dancer.jpg'));

Interest gymnastics = Interest(
    name: 'Gymnastics',
    category: 'Gymnast',
    coverPhoto: Photo(thumbnail: 'assets/categories/gymnast.jpg'));

Interest interiorDesign = Interest(
    name: 'Interior Design',
    category: 'Interior Designer',
    coverPhoto: Photo(thumbnail: 'assets/categories/interior designer.jpg'));

Interest magic = Interest(
    name: 'Magic',
    category: 'Magician',
    coverPhoto: Photo(thumbnail: 'assets/categories/magician.jpg'));

Interest makeup = Interest(
    name: 'Make up',
    category: 'Make up artist',
    coverPhoto: Photo(thumbnail: 'assets/categories/make up artist.jpg'));

Interest modelling = Interest(
    name: 'Modelling',
    category: 'Model',
    coverPhoto: Photo(thumbnail: 'assets/categories/model.jpg'));

Interest music = Interest(
    name: 'Music',
    category: 'Musician',
    coverPhoto: Photo(thumbnail: 'assets/categories/musician.jpg'));

Interest photography = Interest(
    name: 'Photography',
    category: 'Photographer',
    coverPhoto: Photo(thumbnail: 'assets/categories/photographer.jpg'));

Interest puppetry = Interest(
    name: 'Puppetry',
    category: 'Puppet master',
    coverPhoto: Photo(thumbnail: 'assets/categories/puppet master.jpg'));

List<Interest> allCategories = [
  art,
  music,
  photography,
  dance,
  comedy,
  acting,
  modelling,
  gymnastics,
  makeup,
  interiorDesign,
  magic,
  puppetry
];
