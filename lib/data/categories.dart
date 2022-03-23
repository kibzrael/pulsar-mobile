import 'package:pulsar/classes/interest.dart';
import 'package:pulsar/classes/media.dart';

Interest acting = Interest(
    name: 'Acting',
    user: 'Actor',
    coverPhoto: Photo(thumbnail: 'assets/categories/theater-48.png'));

Interest art = Interest(
    name: 'Art',
    user: 'Artist',
    coverPhoto: Photo(thumbnail: 'assets/categories/art-48.png'));

Interest comedy = Interest(
    name: 'Comedy',
    user: 'Comedian',
    coverPhoto: Photo(thumbnail: 'assets/categories/comedy-48.png'));

Interest dance = Interest(
    name: 'Dance',
    user: 'Dancer',
    coverPhoto: Photo(thumbnail: 'assets/categories/dance-48.png'));

Interest gymnastics = Interest(
    name: 'Gymnastics',
    user: 'Gymnast',
    coverPhoto: Photo(thumbnail: 'assets/categories/gymnastics-48.png'));

Interest interiorDesign = Interest(
    name: 'Interior Design',
    user: 'Interior Designer',
    coverPhoto: Photo(thumbnail: 'assets/categories/interior design-48.png'));

Interest magic = Interest(
    name: 'Magic',
    user: 'Magician',
    coverPhoto: Photo(thumbnail: 'assets/categories/magic-48.png'));

Interest makeup = Interest(
    name: 'Make up',
    user: 'Make up artist',
    coverPhoto: Photo(thumbnail: 'assets/categories/makeup art-48.png'));

Interest modelling = Interest(
    name: 'Modelling',
    user: 'Model',
    coverPhoto: Photo(thumbnail: 'assets/categories/modeling-48.png'));

Interest music = Interest(
    name: 'Music',
    user: 'Musician',
    coverPhoto: Photo(thumbnail: 'assets/categories/music-48.png'));

Interest photography = Interest(
    name: 'Photography',
    user: 'Photographer',
    coverPhoto: Photo(thumbnail: 'assets/categories/photography-48.png'));

Interest gaming = Interest(
    name: 'Gaming',
    user: 'Gamer',
    coverPhoto: Photo(thumbnail: 'assets/categories/gaming-48.png'));

Interest puppetry = Interest(
    name: 'Puppetry',
    user: 'Puppet master',
    coverPhoto: Photo(thumbnail: 'assets/categories/puppetry-48.png'));

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
  magic,
  gaming,
  interiorDesign,
  puppetry
];
