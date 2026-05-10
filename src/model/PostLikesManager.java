package src.model;

public class PostLikesManager {
    private final PostStore postStore = new PostStore();

    public void likeImage(String username, String imageID) {
        postStore.likePost(imageID, username);
    }
}
