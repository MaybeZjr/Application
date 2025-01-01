#include "opencv2/opencv.hpp"
#include <vector>

using namespace std;
using namespace cv;

int main(){
    Mat src = imread("2024_crop.jpg", IMREAD_COLOR);
    int w = src.cols;
    int h = src.rows;

    vector<int> col;
    vector<int> row;

    for (int i = 0; i <= 3; i++){
        col.push_back(w * i / 3);
    }
    for (int i = 0; i <= 2; i++){
        row.push_back(h * i / 2);
    }

    vector<Mat> dst;
    int dc = col[1] - col[0];
    int dr = row[1] - row[0];
    dst.push_back(src(Rect(col[0], row[0], dc, dr)));
    dst.push_back(src(Rect(col[1], row[0], dc, dr)));
    dst.push_back(src(Rect(col[2], row[0], dc, dr)));
    dst.push_back(src(Rect(col[0], row[1], dc, dr)));
    dst.push_back(src(Rect(col[1], row[1], dc, dr)));
    dst.push_back(src(Rect(col[2], row[1], dc, dr)));

    string file_name;
    int count = 1;
    for (Mat& i : dst) {
        imshow("Test", i);
        file_name = "2024_crop_";
        file_name.append(to_string(count));
        file_name.append(".jpg");
        count++;
//        imwrite(file_name, i);
        waitKey(0);
    }
    return 0;
}