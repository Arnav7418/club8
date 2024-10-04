import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/experience.dart';
import '../services/experience_service.dart';
import '../providers/experience_providers.dart';


class ExperienceScreen extends ConsumerWidget {
  const ExperienceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final experiencesAsyncValue = ref.watch(experiencesProvider);
    final selectedExperiences = ref.watch(selectedExperiencesProvider);
    final description = ref.watch(descriptionProvider);

    return Scaffold(
      backgroundColor: const Color(0xff101010),
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back),
        //title: const Text("8 club", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xff151515),
      ),
      body: Column(
        children: [
          const Spacer(),
          introSentence(),
          Expanded(
            child: experiencesAsyncValue.when(
              data: (experiences) => ExperienceList(experiences: experiences),
              loading: () => Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
          CustomTextField(
            minLines: 5,
            maxLines: 8,
            inputFormatter: LengthLimitingTextInputFormatter(250),
            hintText: " / Describe your perfect hotspot",
            onChanged: (value) => ref.read(descriptionProvider.notifier).state = value,
          ),
          CustomNextButton(
            text: "Next",
            icon: Icons.arrow_forward,
            onTap: () {
              print('Selected Experience IDs: $selectedExperiences');
              print('Description: $description');
              Navigator.pushNamed(context, "/second");
            },
          ),
        ],
      ),
    );
  }

  Padding introSentence() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Center(
        child: Text(
          "What kind of hotspots do you want to host?",
          style: GoogleFonts.spaceGrotesk(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff),
          ),
        ),
      ),
    );
  }
}

class ExperienceList extends ConsumerWidget {
  final List<Experience> experiences;

  const ExperienceList({Key? key, required this.experiences}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: experiences.length,
      itemBuilder: (context, index) {
        final experience = experiences[index];
        return ExperienceCard(experience: experience);
      },
    );
  }
}

class ExperienceCard extends ConsumerWidget {
  final Experience experience;

  const ExperienceCard({Key? key, required this.experience}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedExperiences = ref.watch(selectedExperiencesProvider);
    final isSelected = selectedExperiences.contains(experience.id);

    return GestureDetector(
      onTap: () {
        ref.read(selectedExperiencesProvider.notifier).toggle(experience.id);
      },
      child: Container(
        width: 150,
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: NetworkImage(isSelected ? experience.imageUrl : experience.iconUrl),
            fit: BoxFit.cover,
            colorFilter: isSelected ? null : const ColorFilter.mode(
              Colors.grey,
              BlendMode.saturation,
            ),
          ),
        ),
        child: isSelected
            ? SizedBox()
            : Center(
                child: Text(
                  experience.name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      const Shadow(
                        blurRadius: 3.0,
                        color: Colors.black,
                        offset: Offset(1.0, 1.0),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final int minLines;
  final int maxLines;
  final TextInputFormatter inputFormatter;
  final String hintText;
  final ValueChanged<String> onChanged;

  const CustomTextField({
    Key? key,
    required this.minLines,
    required this.maxLines,
    required this.inputFormatter,
    required this.hintText,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        inputFormatters: [inputFormatter],
        minLines: minLines,
        maxLines: maxLines,
        onChanged: onChanged,
        style: GoogleFonts.spaceGrotesk(
          fontSize: 20,
          color: const Color(0xffffffff),
        ),
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: hintText,
          fillColor: const Color(0xff151515),
          filled: true,
        ),
      ),
    );
  }
}

class CustomNextButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const CustomNextButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) { 
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ElevatedButton(
        onPressed: onTap, // Maintain the same navigation functionality
        child: const Text("Next"),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff151515),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Color(0x7fffffff)),
          ),
        ),
      ),
    ),
  );
}
    
}
