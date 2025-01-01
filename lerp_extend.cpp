#include "opencv2/opencv.hpp"

using namespace std;
using namespace cv;

#define w Scalar(255, 255, 255)
#define r Scalar(0, 0, 255)
#define g Scalar(0, 255, 0)
#define b Scalar(0, 0, 0)
#define lr Scalar(180, 105, 255)

enum state {EXIT, WAIT};
enum track {TRACK_ENABLE, TRACK_DISABLE};
enum scan_track {SCAN_TRACK_ENABLE, SCAN_TRACK_DISABLE};

class lerp2{
private:
    Point2d p1_;
    Point2d p2_;
public:
    lerp2() = default;
    lerp2(Point2d p1, Point2d p2) : p1_(p1), p2_(p2) {}

    virtual void draw(Mat& src) const {
        line(src, p1_, p2_, w, 2, LINE_AA);
    }

    Point2d getp1() const {
        return p1_;
    }
    Point2d getp2() const {
        return p2_;
    }

    void anim(Mat& src, const double& speed, const state& state) const {
        draw(src);
        Point2d body;
        for (int i = 0; i <= (1 / speed); i++) {
            double t = i * speed;
            body = Point2d(((1 - t) * p1_.x + t * p2_.x), ((1 - t) * p1_.y + t * p2_.y));

            circle(src, body, 10, r, -1,LINE_AA);
            imshow("Test", src);
            circle(src, body, 10, b, -1, LINE_AA);
            draw(src);

            if (waitKey(1) == 27) break;
        }

        if (state == EXIT) waitKey(1);
        if (state == WAIT) waitKey(0);
    }
};

class lerp3: lerp2{
private:
    Point2d p3_;
public:
    lerp3() = default;
    lerp3(Point2d p1, Point2d p2, Point2d p3) : lerp2(p1, p2), p3_(p3) {}

    void draw(Mat& src) const override {
        line(src, getp1(), getp2(), w, 2, LINE_AA);
        line(src, getp2(), p3_, w, 2, LINE_AA);
    }

    void anim(Mat& src, const double& speed, const state& state,
              const track& track, const scan_track& scan_track) const {
        draw(src);
        Point2d body1, body2, dybody;
        for (int i = 0; i <= (1 / speed); i++) {
            double t = i * speed;
            body1 = Point2d(((1 - t) * getp1().x + t * getp2().x),
                            ((1 - t) * getp1().y + t * getp2().y));
            body2 = Point2d(((1 - t) * getp2().x + t * p3_.x),
                            ((1 - t) * getp2().y + t * p3_.y));
            dybody = Point2d(((1 - t) * body1.x + t * body2.x),
                             ((1 - t) * body1.y + t * body2.y));

            circle(src, body1, 5, r, -1,LINE_AA);
            circle(src, body2, 5, r, -1,LINE_AA);
            circle(src, dybody, 10, g, -1,LINE_AA);
            line(src, body1, body2, lr, 2, LINE_AA);
            imshow("Test", src);
            circle(src, body1, 5, b, -1, LINE_AA);
            circle(src, body2, 5, b, -1,LINE_AA);
            if (track == TRACK_DISABLE) circle(src, dybody, 10, b, -1,LINE_AA);
            line(src, body1, body2, b, (scan_track == SCAN_TRACK_ENABLE) ? 1 : 3, LINE_AA);
            draw(src);

            if (waitKey(1) == 27) break;
        }

        if (state == EXIT) waitKey(1);
        if (state == WAIT) waitKey(0);
    }
};

int main(){
    Mat src = Mat::zeros(Size(2000, 2000), CV_8UC3);

//    lerp2 a(Point2d(200, 200), Point2d(1000, 1000));
//    a.anim(src, 0.0075, EXIT);
//
//    imshow("Test", src);
//    waitKey(0);

    lerp3 c(Point2d(200, 600), Point2d(1500, 900), Point2d(600, 1700));
    c.anim(src, 0.005, EXIT, TRACK_ENABLE, SCAN_TRACK_DISABLE);

    waitKey(0);
    return 0;
}