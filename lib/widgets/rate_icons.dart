import 'package:flutter/material.dart';

typedef void RatingChangeCallback(double rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback onRatingChanged;
  final Color color;
  final String position;
  final double size;

  StarRating(
      {this.starCount = 5,
      this.rating = .0,
      this.onRatingChanged,
      this.color,
      this.position,
      this.size});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = new Icon(
        Icons.star_border,
        color: Theme.of(context).buttonColor,
        size: size,
      );
    } else if (index > rating - 1 && index < rating) {
      icon = new Icon(
        Icons.star_half,
        size: size,
        color: color ?? Theme.of(context).primaryColor,
      );
    } else {
      icon = new Icon(
        Icons.star,
        size: size,
        color: color ?? Theme.of(context).primaryColor,
      );
    }
    return new InkResponse(
      onTap:
          onRatingChanged == null ? null : () => onRatingChanged(index + 1.0),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return (position == "left")
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: new List.generate(
                starCount, (index) => buildStar(context, index)))
        : (position == "center")
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: new List.generate(
                    starCount, (index) => buildStar(context, index)))
            : (position == "right")
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: new List.generate(
                        starCount, (index) => buildStar(context, index)))
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: new List.generate(
                        starCount, (index) => buildStar(context, index)));
  }
}
