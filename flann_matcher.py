import cv2 as cv
import matplotlib.pyplot as plt
import numpy as np


def flann_matches_mask(img1_path: str, img2_path: str):
    img1 = cv.imread(img1_path, cv.IMREAD_GRAYSCALE)
    img2 = cv.imread(img2_path, cv.IMREAD_GRAYSCALE)

    sift = cv.SIFT_create() #to find local features  in image

    kp1, des1 = sift.detectAndCompute(img1, None)
    kp2, des2 = sift.detectAndCompute(img2, None)
    #to find the keypoints kp1 and  make descriptor of these points to describe the area around this point
    des1 = np.float32(des1) # we turn teh numbers into 32-bit decimal numbers ebcause flann matcher expcets 32bit
    des2 = np.float32(des2)

    # FLANN parameters
    FLANN_INDEX_KDTREE = 1 #picks the KD-tree as search method
    index_params = dict(algorithm=FLANN_INDEX_KDTREE, trees=5) #to build 5 search trees
    search_params = dict(checks=50)  # how many branches to check during the search

    flann = cv.FlannBasedMatcher(index_params, search_params) #creates matcher object
    matches = flann.knnMatch(des1, des2, k=2) #take the top 2 closet matching points from img1 and img2

    matchesMask = [[0, 0] for _ in range(len(matches))]

    # it compare m (top best match from img2 ) with n (next point matches) and if the if condition was right we take m as best descpitor [1,0] else we keep it [0,0]
    for i, (m, n) in enumerate(matches):
        if m.distance < 0.7 * n.distance:
            matchesMask[i] = [1, 0]

    draw_params = dict(
        matchColor=(0, 255, 0), 
        singlePointColor=(255, 0, 0),
        matchesMask=matchesMask,
        flags=cv.DrawMatchesFlags_NOT_DRAW_SINGLE_POINTS, # does'nt draw teh points that have no match line
    )

    img3 = cv.drawMatchesKnn(img1, kp1, img2, kp2, matches, None, **draw_params) #unpacks the ditionary keys  and values
    return img3


if __name__ == "__main__":

    img1_path = "tesla1.png"
    img2_path = "tesla2.png"

    img3 = flann_matches_mask(img1_path, img2_path)
    img3_rgb = cv.cvtColor(img3, cv.COLOR_BGR2RGB)

    plt.figure(figsize=(12, 6))
    plt.imshow(img3_rgb)
    plt.axis("off")
    plt.tight_layout()
    plt.show()
