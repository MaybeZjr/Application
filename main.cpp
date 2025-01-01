#include <vector>
#include <cmath>
#include "opencv2/opencv.hpp"

using namespace std;
using namespace cv;

#define w Scalar(255, 255, 255)
#define r Scalar(0, 0, 255)
#define b Scalar(0, 0, 0)
#define spd 5.0f

enum state {EXIT, WAIT};

class lerp {
private:
    vector<Point2f> line1_;
    vector<Point2f> line2_;
public:
    lerp() : line1_(2), line2_(2) {}
    lerp(const Point2f& L1A, const Point2f& L1B, const Point2f& L2A, const Point2f& L2B) {
        line1_.resize(2);
        line2_.resize(2);
        line1_[0] = L1A;
        line1_[1] = L1B;
        line2_[0] = L2A;
        line2_[1] = L2B;
    }

    void draw(Mat& src) const {
        line(src, line1_[0], line1_[1], w, 2, LINE_AA);
        line(src, line2_[0], line2_[1], w, 2, LINE_AA);
    }

    void anim(Mat& src, const state& state) const {
        vector<Point2f> move(2);
        move[0] = line1_[0];
        move[1] = line2_[0];
        float ab_dx1, ab_dy1, ab_dx2, ab_dy2;
        float po_l1_x = 1, po_l1_y = 1, po_l2_x = 1, po_l2_y = 1;
        float dx1, dy1, dx2, dy2;

        ab_dx1 = line1_[0].x - line1_[1].x;
        ab_dy1 = line1_[0].y - line1_[1].y;
        ab_dx2 = line2_[0].x - line2_[1].x;
        ab_dy2 = line2_[0].y - line2_[1].y;

        if (ab_dx1 > 0) po_l1_x = -1;
        if (ab_dy1 > 0) po_l1_y = -1;
        if (ab_dx2 > 0) po_l2_x = -1;
        if (ab_dy2 > 0) po_l2_y = -1;

        dx1 = fabs(ab_dx1);
        dx2 = fabs(ab_dx2);
        dy2 = fabs(ab_dy2);
        dy1 = fabs(ab_dy1);

        if (dx1 >= dy1) {
            float tempx1 = line1_[0].x;
            float tempx2 = line1_[1].x;
            if (tempx2 < tempx1) {
                float temp = tempx1;
                tempx1 = tempx2;
                tempx2 = temp;
            }
            for (int i = static_cast<int>(tempx1); i <= static_cast<int>(tempx2); i++) {
                if (po_l1_x == 1) if (move[0].x > line1_[1].x) break;
                if (po_l1_x == -1) if (move[0].x < line1_[1].x) break;

                (move[0].x) += spd * po_l1_x;
                (move[0].y) += spd * dy1 / dx1 * po_l1_y;

                move[1].x = ((po_l2_x == 1) ? (-dx2) : (dx2)) * ((move[0].x - line1_[0].x) / dx1) + line2_[0].x;
                move[1].y = ((po_l2_y == 1) ? (-dy2) : (dy2)) * ((move[0].x - line1_[0].x) / dx1) + line2_[0].y;

                circle(src, move[0], 10, r, -1, LINE_AA);
                circle(src, move[1], 10, r, -1, LINE_AA);
                imshow("Test", src);
                circle(src, move[0], 10, b, -1, LINE_AA);
                circle(src, move[1], 10, b, -1, LINE_AA);
                draw(src);
                if (waitKey(1) == 27) break;
            }
        }
        else {
            float tempy1 = line1_[0].y;
            float tempy2 = line1_[1].y;
            if (tempy2 < tempy1) {
                float temp = tempy1;
                tempy1 = tempy2;
                tempy2 = temp;
            }
            for (int i = static_cast<int>(tempy1); i <= static_cast<int>(tempy2); i++) {
                if (po_l1_y == 1) if (move[0].y > line1_[1].y) break;
                if (po_l1_y == -1) if (move[0].y < line1_[1].y) break;

                (move[0].y) += spd * po_l1_y;
                (move[0].x) += spd * dx1 / dy1 * po_l1_x;

                move[1].x = ((po_l2_x == 1) ? (-dx2) : (dx2)) * ((move[0].y - line1_[0].y) / dy1) + line2_[0].x;
                move[1].y = ((po_l2_y == 1) ? (-dy2) : (dy2)) * ((move[0].y - line1_[0].y) / dy1) + line2_[0].y;

                circle(src, move[0], 10, r, -1, LINE_AA);
                circle(src, move[1], 10, r, -1, LINE_AA);
                imshow("Test", src);
                circle(src, move[0], 10, b, -1, LINE_AA);
                circle(src, move[1], 10, b, -1, LINE_AA);
                draw(src);
                if (waitKey(1) == 27) break;
            }
        }
        if (state == EXIT) waitKey(1);
        if (state == WAIT) waitKey(0);
    }
};

int main(){
    Mat src = Mat::zeros(Size(2000, 2000), CV_8UC3);

    vector<Point2f> lib = {Point2f(1600, 1250), Point2f(600, 1250),
                           Point2f(600, 400), Point2f(1200, 400)};

    lerp inst(lib[0], lib[1], lib[2], lib[3]);
    inst.draw(src);
    inst.anim(src, WAIT);

    return 0;
}