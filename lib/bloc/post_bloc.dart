import 'package:petland/model/post.dart';
import 'package:petland/repo/post_repo.dart';
import 'package:petland/services/base_response.dart';
import 'package:petland/share/import.dart';

class PostBloc extends ChangeNotifier {
  PostBloc._privateConstructor();
  static final PostBloc instance = PostBloc._privateConstructor();

  List<PostModel> posts = [];

  Future<BaseResponse> getListPost() async {
    try {
      final String id = await SPref.instance.get('id');
      final res = await PostRepo().getList(userId: id);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => PostModel.fromJson(e)).toList();
      posts = list;
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.message?.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> updatePost(PostModel post) async {
    try {
      final res = await PostRepo().update(post: post);
      posts[posts.indexWhere((element) => element.id == post.id)] = post;
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.message?.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> createPost(PostModel post) async {
    try {
      final String id = await SPref.instance.get('id');
      post.userId = id;
      final res = await PostRepo().create(post: post);
      posts.add(PostModel.fromJson(res));
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.message?.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> deletePost(String postId) async {
    try {
      final res = await PostRepo().delete(postId: postId);
      posts.removeWhere((element) => element.id == postId);
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.message?.toString());
    } finally {
      notifyListeners();
    }
  }
}