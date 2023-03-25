import 'dart:ffi';

import 'package:moviebooking/data/model/movie_booking_model.dart';
import 'package:moviebooking/data/vos/actor_vo.dart';
import 'package:moviebooking/data/vos/banner_vo.dart';
import 'package:moviebooking/data/vos/cinema_config_vo.dart';
import 'package:moviebooking/data/vos/cinema_show_time_vo.dart';
import 'package:moviebooking/data/vos/city_vo.dart';
import 'package:moviebooking/data/vos/movie_detail_vo.dart';
import 'package:moviebooking/data/vos/movie_vo.dart';
import 'package:moviebooking/data/vos/seating_plan_vo.dart';
import 'package:moviebooking/data/vos/time_slot_config_vo.dart';
import 'package:moviebooking/data/vos/trailer_video_vo.dart';
import 'package:moviebooking/data/vos/user_data_vo.dart';
import 'package:moviebooking/network/movie_booking_data_agent.dart';
import 'package:moviebooking/network/movie_booking_data_agent_impl.dart';
import 'package:moviebooking/persistence/daos/banner_dao.dart';
import 'package:moviebooking/persistence/daos/movie_dao.dart';
import 'package:moviebooking/persistence/daos/movie_detail_dao.dart';
import 'package:moviebooking/persistence/daos/timeslot_config_dao.dart';
import 'package:moviebooking/persistence/daos/user_data_dao.dart';
import 'package:moviebooking/utils/ext.dart';

class MovieBookingModelImpl extends MovieBookingModel {
  MovieBookingDataAgent movieBookingDataAgent = MovieBookingDataAgentImpl();

  MovieBookingModelImpl._internal();

  static final MovieBookingModelImpl _singleton =
      MovieBookingModelImpl._internal();

  factory MovieBookingModelImpl() => _singleton;

  BannerDao bannerDao = BannerDao();
  MovieDao movieDao = MovieDao();
  MovieDetailDao movieDetailDao = MovieDetailDao();
  UserDataDao userDataDao = UserDataDao();
  TimeSlotConfigDao timeSlotConfigDao = TimeSlotConfigDao();

  @override
  Future<String> getOTP(String phone) {
    return movieBookingDataAgent.getOTP(phone);
  }

  @override
  Future<UserDataVo?> signInWithPhone(String phone, String otpCode) {
    return movieBookingDataAgent.signInWithPhone(phone, otpCode);
  }

  @override
  Future<List<CityVo?>> getCities() {
    return movieBookingDataAgent.getCities();
  }

  @override
  Future<List<BannerVo?>> getBanners() {
    return movieBookingDataAgent.getBanners().then((value) async {
      bannerDao.saveAllBanners(value.orEmptyObject);
      return Future.value(value);
    });
  }

  @override
  Future<List<MovieVo?>> getMovies(String status) {
    return movieBookingDataAgent.getMovies(status).then((value) async {
      List<MovieVo?> list;
      if (status == "current") {
        list = value.map((e) {
          e?.isCurrent = true;
          e?.isComingSoon = false;
          return e;
        }).toList();
      } else {
        list = value.map((e) {
          e?.isCurrent = false;
          e?.isComingSoon = true;
          return e;
        }).toList();
      }
      movieDao.saveAllMovies(list.orEmptyObject);
      return Future.value(value);
    });
  }

  @override
  Future<List<CinemaConfigVo?>> getCinemaConfig() {
    return movieBookingDataAgent.getCinemaConfig();
  }

  @override
  Future<MovieDetailVo> getMovieDetails(int movieId) {
    return movieBookingDataAgent.getMovieDetails(movieId).then((value) {
      movieDetailDao.saveMovieDetail(value);
      return Future.value(value);
    });
  }

  @override
  Future<TrailerVideoVo?> getTrailerVideo(int movieId) {
    return movieBookingDataAgent.getTrailerVideo(movieId);
  }

  @override
  Future<List<ActorVo>> getCreditsByMovie(int movieId) {
    return movieBookingDataAgent.getCreditsByMovie(movieId);
  }

  @override
  Future<List<CinemaShowTimeVo?>> getCinemaShowTimeByDate(String date) {
    return movieBookingDataAgent.getCinemaShowTimeByDate(date);
  }

  @override
  Future<List<List<SeatingPlanVo>?>> getSeatingPlanByShowTime(
      int cinemaTimeSlotId, String bookingDate) {
    return movieBookingDataAgent.getSeatingPlanByShowTime(
        cinemaTimeSlotId, bookingDate);
  }

  /// From Database

  @override
  Future<List<BannerVo?>> getBannersFromDb() {
    return Future.value(bannerDao.getAllBanner());
  }

  @override
  Future<List<MovieVo?>> getMoviesFromDb(String status) {
    return Future.value(movieDao.getMoviesByStatus(status));
  }

  @override
  Future<MovieDetailVo?> getMovieDetailFromDb(int movieId) {
    return Future.value(movieDetailDao.getMovieDetail(movieId));
  }

  @override
  UserDataVo? getUserDataFromDb() {
    return userDataDao.getUserData();
  }

  @override
  void saveUserDataToDb(UserDataVo userData) {
    userDataDao.saveUserData(userData);
  }

  @override
  TimeSlotConfigVo? getTimeSlotConfigFromDb(int id) {
    return timeSlotConfigDao.getById(id);
  }

  @override
  void saveTimeSlotConfigsToDb(List<TimeSlotConfigVo> list) {
    timeSlotConfigDao.saveAll(list);
  }
}
