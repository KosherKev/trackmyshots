import 'package:flutter/material.dart';
import 'package:trackmyshots/models/models.dart';

class EducationalDetailScreen extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;

  const EducationalDetailScreen({
    super.key,
    required this.title,
    required this.content,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon header
            Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF0066B3).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 64,
                  color: const Color(0xFF0066B3),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Content
            Text(
              content,
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Educational content factory
  static Widget vaccinePurpose(BuildContext context) {
    return const EducationalDetailScreen(
      title: 'Vaccine Purpose',
      icon: Icons.article_outlined,
      content: '''Vaccines are one of the most important tools in preventing serious diseases and protecting public health. They work by training your child's immune system to recognize and fight off harmful germs before they can cause illness.

Why Vaccines Matter:

• Disease Prevention: Vaccines protect against serious illnesses like measles, polio, whooping cough, and more. Many of these diseases can cause severe complications, permanent disabilities, or even death.

• Community Protection: When enough people are vaccinated, it creates "herd immunity" that protects those who cannot be vaccinated, such as newborns and people with weakened immune systems.

• Long-term Health: Vaccination in childhood provides protection that often lasts a lifetime, preventing diseases that could affect your child's development, education, and future health.

How Vaccines Work:

Vaccines contain weakened or inactive parts of a particular germ (antigen) that triggers an immune response. Your child's body produces antibodies that "remember" how to fight that disease in the future. If exposed to the real disease later, their immune system is ready to protect them.

The recommended immunization schedule is carefully designed by medical experts to provide protection when children are most vulnerable to these diseases.''',
    );
  }

  static Widget sideEffects(BuildContext context) {
    return const EducationalDetailScreen(
      title: 'Potential Side Effects',
      icon: Icons.warning_amber_outlined,
      content: '''Like any medicine, vaccines can cause side effects. However, most side effects are minor and temporary, and serious side effects are extremely rare.

Common Side Effects (Usually Mild):

• Soreness, redness, or swelling at the injection site
• Low-grade fever (under 101°F)
• Fussiness or irritability
• Decreased appetite
• Mild rash
• Drowsiness or tiredness

These symptoms typically appear within a few hours to 2 days after vaccination and usually resolve on their own within 1-3 days.

How to Manage Side Effects:

• Apply a cool, wet cloth to the injection site to reduce pain and swelling
• Give plenty of fluids
• Dress your child in light clothing if they have a fever
• Use acetaminophen or ibuprofen for pain or fever (ask your doctor for proper dosing)
• Monitor your child and provide extra comfort

When to Call Your Doctor:

While serious reactions are rare, contact your healthcare provider if your child experiences:
• High fever (over 104°F)
• Seizures or convulsions
• Severe allergic reaction (difficulty breathing, swelling of face/throat)
• Behavior changes or unusual crying that lasts several hours
• Extreme drowsiness or difficulty waking

Remember: The risks from vaccine-preventable diseases are far greater than the risk of side effects from vaccines. Vaccines have been given to millions of children safely for decades.''',
    );
  }

  static Widget adherenceImportance(BuildContext context) {
    return const EducationalDetailScreen(
      title: 'Importance of Adherence',
      icon: Icons.verified_outlined,
      content: '''Following the recommended vaccination schedule is crucial for protecting your child's health. Here's why staying on schedule matters:

Why Timing Matters:

• Optimal Protection: Vaccines are scheduled when children are most vulnerable to specific diseases. Delaying vaccines leaves your child unprotected during critical developmental periods.

• Immune System Development: The schedule is designed to work with your child's developing immune system, providing protection when it's most needed and most effective.

• Series Completion: Many vaccines require multiple doses to provide full protection. Missing doses or delaying them can reduce effectiveness.

Benefits of Staying on Schedule:

• Maximum Protection: Following the schedule ensures your child receives protection at the right time, before potential exposure to diseases.

• Catch-Up Prevention: Staying current prevents the need for "catch-up" schedules, which can be more complicated and require additional visits.

• School Requirements: Most schools and childcare facilities require up-to-date vaccinations for enrollment.

• Travel Safety: If you plan to travel, especially internationally, current vaccinations are essential.

What If You Miss a Dose?

• Contact your healthcare provider as soon as possible
• There's usually no need to restart the series; just continue where you left off
• Your doctor can create a catch-up schedule
• Don't wait - get back on track quickly

Tips for Staying on Schedule:

• Set reminders on your phone or calendar
• Use this app's reminder feature
• Keep vaccination records easily accessible
• Schedule the next appointment before leaving each visit
• Ask your doctor about combination vaccines to reduce the number of shots

Remember: Preventing disease is always easier and safer than treating it. Staying on schedule protects your child and your community.''',
    );
  }

  static Widget immunizationOverview(BuildContext context) {
    return const EducationalDetailScreen(
      title: 'Immunization Overview',
      icon: Icons.vaccines_outlined,
      content: '''Understanding immunization helps you make informed decisions about your child's health. Here's a comprehensive overview of childhood vaccinations.

What is Immunization?

Immunization is the process of making a person immune or resistant to an infectious disease, typically by administering a vaccine. Vaccines stimulate the body's own immune system to protect against subsequent infection or disease.

Types of Vaccines:

• Live Attenuated: Weakened form of the germ (e.g., MMR, chickenpox)
• Inactivated: Killed version of the germ (e.g., polio, hepatitis A)
• Subunit/Conjugate: Use specific pieces of the germ (e.g., Hib, pneumococcal)
• Toxoid: Use a toxin made by the germ (e.g., diphtheria, tetanus)
• mRNA: Teach cells to make a protein that triggers immune response (newer technology)

Key Vaccines in Childhood:

1. Hepatitis B: Protects liver function
2. Rotavirus: Prevents severe diarrhea and dehydration
3. DTaP: Protects against diphtheria, tetanus, and pertussis (whooping cough)
4. Hib: Prevents Haemophilus influenzae type b infections
5. Pneumococcal (PCV): Protects against pneumonia and meningitis
6. Polio: Prevents paralytic polio disease
7. MMR: Protects against measles, mumps, and rubella
8. Varicella: Prevents chickenpox
9. Hepatitis A: Protects against liver disease

Vaccine Safety:

• Vaccines undergo rigorous testing before approval
• Continuous monitoring after approval ensures ongoing safety
• Benefits far outweigh minimal risks
• Millions of doses given safely each year
• Modern vaccines are safer and more effective than ever

Vaccine Myths vs. Facts:

Myth: "Natural immunity is better than vaccine-acquired immunity"
Fact: Natural infection can cause serious complications or death. Vaccines provide immunity without the disease.

Myth: "Too many vaccines overwhelm the immune system"
Fact: Children's immune systems handle thousands of antigens daily. Vaccines represent a tiny fraction of this exposure.

Myth: "Vaccines cause autism"
Fact: Extensive research has found no link between vaccines and autism. The original study making this claim was fraudulent and retracted.

Your Role as a Parent:

• Keep vaccination records up to date
• Follow the recommended schedule
• Ask questions - your healthcare provider is there to help
• Watch for side effects and know when to call the doctor
• Share accurate information with other parents

Remember: Vaccination is one of the safest and most effective ways to protect your child's health and prevent serious diseases.''',
    );
  }

  static Widget forVaccine(BuildContext context, Vaccine vaccine) {
    return EducationalDetailScreen(
      title: vaccine.name,
      icon: Icons.vaccines,
      content: '''${vaccine.description}

Purpose:
${vaccine.purpose}

Recommended Schedule:
${vaccine.administrationSchedule}

Potential Side Effects:
${vaccine.sideEffects}''',
    );
  }
}
