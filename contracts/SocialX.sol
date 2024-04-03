// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SocialX {
    struct Post {
        uint256 id;
        address author;
        string content;
        uint256 likes;
        address[] likers;
        uint256 unlikes;
        address[] unlikers;
        uint256 timestamp;
    }

    mapping(address => Post[]) private posts;

    address[] emptyAddressList;

    function createPost(string memory _content) public {
        Post memory newPost = Post({
            id: posts[msg.sender].length,
            author: msg.sender,
            content: _content,
            likes: 0,
            likers: emptyAddressList,
            unlikes: 0,
            unlikers: emptyAddressList,
            timestamp: block.timestamp
        });

        posts[msg.sender].push(newPost);
    }

    function likePost(address _author, uint256 _postId) external {
        require(posts[_author][_postId].id == _postId, "Post id not found");
        for (uint256 i = 0; i < posts[_author][_postId].likers.length; i++) {
            require(
                posts[_author][_postId].likers[i] != msg.sender,
                "You already liked this post"
            );
        }

        for (uint256 i = 0; i < posts[_author][_postId].unlikers.length; i++) {
            if (posts[_author][_postId].unlikers[i] == msg.sender) {
                posts[_author][_postId].unlikers[i] = posts[_author][_postId]
                    .unlikers[posts[_author][_postId].unlikers.length - 1];
                posts[_author][_postId].unlikers.pop();
                posts[_author][_postId].unlikes =
                    posts[_author][_postId].unlikes -
                    1;
            }
        }

        posts[_author][_postId].likers.push(msg.sender);
        posts[_author][_postId].likes++;
    }

    function unlikePost(address _author, uint256 _postId) external {
        require(posts[_author][_postId].id == _postId, "Post id not found");
        for (uint256 i = 0; i < posts[_author][_postId].unlikers.length; i++) {
            require(
                posts[_author][_postId].unlikers[i] != msg.sender,
                "You already unliked this post"
            );
        }

        for (uint256 i = 0; i < posts[_author][_postId].likers.length; i++) {
            if (posts[_author][_postId].likers[i] == msg.sender) {
                posts[_author][_postId].likers[i] = posts[_author][_postId]
                    .likers[posts[_author][_postId].likers.length - 1];
                posts[_author][_postId].likers.pop();
                posts[_author][_postId].likes =
                    posts[_author][_postId].likes -
                    1;
            }
        }

        posts[_author][_postId].unlikers.push(msg.sender);
        posts[_author][_postId].unlikes++;
    }

    function getAllAuthorPosts(
        address author
    ) external view returns (Post[] memory) {
        return posts[author];
    }

    function getAllPostLikes(
        address _author,
        uint256 _postId
    ) external view returns (uint256) {
        return posts[_author][_postId].likes;
    }

    function getAllPostUnlikes(
        address _author,
        uint256 _postId
    ) external view returns (uint256) {
        return posts[_author][_postId].unlikes;
    }

    function getAllPostLikers(
        address _author,
        uint256 _postId
    ) external view returns (address[] memory) {
        return posts[_author][_postId].likers;
    }

    function getAllPostUnlikers(
        address _author,
        uint256 _postId
    ) external view returns (address[] memory) {
        return posts[_author][_postId].unlikers;
    }
}
