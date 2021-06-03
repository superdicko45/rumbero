import '../model_reponses/enlace_model_response.dart';
import '../model_reponses/video_model_response.dart';
import '../model_reponses/event_model_response.dart';
import '../model_reponses/blog_model_response.dart';
import '../models/category_model.dart';

class HomeResponse {
  List<BlogModelResponse> blogs;
  List<EventModelResponse> recomendados;
  List<Category> categories;
  List<EnlaceModelResponse> enlaces;
  List<VideoModelResponse> videos;
  bool error;

  HomeResponse(
      {this.recomendados,
      this.categories,
      this.blogs,
      this.enlaces,
      this.videos,
      this.error});

  HomeResponse.fromJson(Map<String, dynamic> json) {
    if (json['blogs'] == null &&
        json['generos'] == null &&
        json['recomendados'] == null &&
        json['videos'] == null &&
        json['enlaces'] == null)
      error = true;
    else
      error = false;

    if (json['recomendados'] != null) {
      recomendados = new List<EventModelResponse>();
      json['recomendados'].forEach((v) {
        recomendados.add(new EventModelResponse.fromJson(v));
      });
    }

    if (json['blogs'] != null) {
      blogs = new List<BlogModelResponse>();
      json['blogs'].forEach((v) {
        blogs.add(new BlogModelResponse.fromJson(v));
      });
    }

    if (json['enlaces'] != null) {
      enlaces = new List<EnlaceModelResponse>();
      json['enlaces'].forEach((v) {
        enlaces.add(new EnlaceModelResponse.fromJson(v));
      });
    }

    if (json['videos'] != null) {
      videos = new List<VideoModelResponse>();
      json['videos'].forEach((v) {
        videos.add(new VideoModelResponse.fromJson(v));
      });
    }

    if (json['generos'] != null) {
      categories = new List<Category>();
      json['generos'].forEach((v) {
        categories.add(new Category.fromJson(v));
      });
    }
  }

  HomeResponse.withError(String errorValue) {
    error = true;
  }
}
