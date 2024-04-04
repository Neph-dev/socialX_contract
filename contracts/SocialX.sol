// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SocialX {
    struct Post {
        uint256 id;
        address author;
        string content;
        uint256 likes;
        address[] likers;
        uint256 hates;
        address[] haters;
        uint256 timestamp;
    }

    mapping(address => Post[]) private posts;
    Post[] private allPosts;

    address[] emptyAddressList;
    uint16 public MAX_TWEET_LENGTH = 280;

    function createPost(string memory _content) public {
        require(
            bytes(_content).length <= MAX_TWEET_LENGTH,
            "Content is too long."
        );
        require(bytes(_content).length == 0, "Content is too long.");

        Post memory newPost = Post({
            id: allPosts.length,
            author: msg.sender,
            content: _content,
            likes: 0,
            likers: emptyAddressList,
            hates: 0,
            haters: emptyAddressList,
            timestamp: block.timestamp
        });

        posts[msg.sender].push(newPost);
        allPosts.push(newPost);
    }

    function likePost(address _author, uint256 _postId) external {
        require(posts[_author][_postId].id == _postId, "Post id not found");

        // * Check if the sender hasn't already liked the post.
        for (uint256 i = 0; i < posts[_author][_postId].likers.length; i++) {
            require(
                posts[_author][_postId].likers[i] != msg.sender,
                "You already liked this post"
            );
        }

        // * Check if the sender has already unliked the post. If yes, remove it.
        for (uint256 i = 0; i < posts[_author][_postId].haters.length; i++) {
            if (posts[_author][_postId].haters[i] == msg.sender) {
                posts[_author][_postId].haters[i] = posts[_author][_postId]
                    .haters[posts[_author][_postId].haters.length - 1];

                posts[_author][_postId].haters.pop();
                posts[_author][_postId].hates =
                    posts[_author][_postId].hates -
                    1;
            }
        }

        posts[_author][_postId].likers.push(msg.sender);
        posts[_author][_postId].likes++;

        // * Update the allPosts array
        for (uint256 i = 0; i < allPosts.length; i++) {
            if (allPosts[i].id == _postId && allPosts[i].author == _author) {
                allPosts[i].likers.push(msg.sender);
                allPosts[i].likes++;

                for (uint256 j = 0; j < allPosts[i].haters.length; j++) {
                    if (allPosts[i].haters[j] == msg.sender) {
                        allPosts[i].haters[j] = allPosts[i].haters[
                            allPosts[i].haters.length - 1
                        ];
                        allPosts[i].haters.pop();
                        allPosts[i].hates--;
                        break;
                    }
                }
                break;
            }
        }
    }

    function unlikePost(address _author, uint256 _postId) external {
        require(posts[_author][_postId].id == _postId, "Post id not found");
        for (uint256 i = 0; i < posts[_author][_postId].haters.length; i++) {
            require(
                posts[_author][_postId].haters[i] != msg.sender,
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

        posts[_author][_postId].haters.push(msg.sender);
        posts[_author][_postId].hates++;

        // * Update the allPosts array
        for (uint256 i = 0; i < allPosts.length; i++) {
            if (allPosts[i].id == _postId && allPosts[i].author == _author) {
                allPosts[i].haters.push(msg.sender);
                allPosts[i].hates++;

                for (uint256 j = 0; j < allPosts[i].likers.length; j++) {
                    if (allPosts[i].likers[j] == msg.sender) {
                        allPosts[i].likers[j] = allPosts[i].likers[
                            allPosts[i].likers.length - 1
                        ];
                        allPosts[i].likers.pop();
                        allPosts[i].likes--;
                        break;
                    }
                }
                break;
            }
        }
    }

    function getAllPosts() external view returns (Post[] memory) {
        return allPosts;
    }

    function getAuthorPosts(
        address author
    ) external view returns (Post[] memory) {
        return posts[author];
    }

    function getPostLikes(
        address _author,
        uint256 _postId
    ) external view returns (uint256) {
        return posts[_author][_postId].likes;
    }

    function getPostHates(
        address _author,
        uint256 _postId
    ) external view returns (uint256) {
        return posts[_author][_postId].hates;
    }

    function getPostLikers(
        address _author,
        uint256 _postId
    ) external view returns (address[] memory) {
        return posts[_author][_postId].likers;
    }

    function getPostHaters(
        address _author,
        uint256 _postId
    ) external view returns (address[] memory) {
        return posts[_author][_postId].haters;
    }
}
