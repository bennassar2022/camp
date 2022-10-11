import 'package:camping/mock_data/states_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StateWdiget extends StatelessWidget {
  final StateModel state;
  const StateWdiget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
              bottomRight: Radius.circular(18),
              bottomLeft: Radius.circular(18),
            ),
            image: DecorationImage(
              image: AssetImage(
                state.image,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 5,
                right: -15,
                child: MaterialButton(
                  color: Colors.white,
                  shape: CircleBorder(),
                  onPressed: () {},
                  child: Icon(
                    Icons.favorite_outline_rounded,
                    color: Colors.lightGreen,
                    size: 20,
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(15, 5, 20, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                state.name,
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  color: Colors.black45,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Row(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.star_rate,
                        color: Colors.lightGreen,
                        size: 14.0,
                      ),
                      Icon(
                        Icons.star_rate,
                        color: Colors.lightGreen,
                        size: 14.0,
                      ),
                      Icon(
                        Icons.star_rate,
                        color: Colors.lightGreen,
                        size: 14.0,
                      ),
                      Icon(
                        Icons.star_rate,
                        color: Colors.lightGreen,
                        size: 14.0,
                      ),
                      Icon(
                        Icons.star_border,
                        color: Colors.lightGreen,
                        size: 14.0,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
