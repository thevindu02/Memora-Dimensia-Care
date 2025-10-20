# Individual Self-Reflection Report
## Third Year Group Project - Memora: Dementia Care Companion

**Student Name:** [Your Name]  
**Student ID:** [Your ID]  
**Project:** Memora - A Personalized Dementia Care Companion  
**Date:** October 20, 2025

---

## 1. Myself in Five Words

**Dedicated, Adaptive, Detail-Oriented, Collaborative, Problem-Solver**

---

## 2. Learning Journey and Future Benefits

Throughout this third-year group project, I have gained invaluable experience across multiple dimensions of software development that will significantly benefit my future career.

### Technical Skills Acquired

**Mobile Development Expertise:** Working extensively with Flutter and Dart, I developed over 56 commits contributing 30,000+ lines of code across 560 files. I gained hands-on experience building cross-platform mobile applications, implementing complex navigation patterns, state management, and integrating REST APIs. The patient, guardian, caregiver, and volunteer modules I developed taught me how to create intuitive, user-centric interfaces for diverse user groups with varying technical abilities.

**Backend Integration:** I learned to seamlessly integrate mobile applications with Spring Boot backends, implementing robust authentication systems, API consumption, and error handling. The experience with Firebase integration for real-time features and push notifications enhanced my understanding of cloud services and serverless architectures.

**Full-Stack Thinking:** Developing features end-to-end—from backend controllers and services to mobile UI screens—taught me to think holistically about software architecture. I learned how design decisions in one layer impact the entire system, making me a more comprehensive developer.

### Software Engineering Practices

**Version Control Mastery:** Managing multiple branches (dev-minha1, dev-minha1-copy, minha) and coordinating code merges taught me Git workflow best practices essential for professional development teams. I learned the importance of meaningful commit messages, branch strategies, and handling merge conflicts.

**Agile Development:** Working in sprints, breaking down features into manageable tasks, and continuously integrating code taught me agile methodologies that are industry-standard in modern software companies.

**Code Quality and Debugging:** Fixing numerous bugs and errors (evident from commits like "fixed errors," "fix network error," "Fixed UI colors") developed my debugging skills and attention to code quality. I learned systematic approaches to troubleshooting and the importance of thorough testing.

### Domain-Specific Knowledge

**Healthcare Technology:** Developing for dementia care gave me insight into healthcare software requirements, including accessibility, data sensitivity, and user experience for vulnerable populations. Understanding dementia stages and how they affect feature requirements taught me empathy-driven design.

**Payment Integration:** Implementing subscription plans and PayHere payment gateway integration provided practical experience with e-commerce and payment processing—a valuable skill across industries.

### Future Career Benefits

These skills directly align with industry demands for mobile developers and full-stack engineers. The experience of building a production-ready application from scratch, handling real-world challenges like network errors, authentication flows, and complex user workflows has prepared me for professional software development roles. The collaborative aspects have refined my communication and teamwork abilities, essential for any technical career.

---

## 3. Group Work Experience, Role, and Contributions

### My Role in the Team

I primarily served as the **Mobile Application Lead Developer**, focusing on the Flutter mobile app development while contributing to backend integration and system architecture decisions. My role evolved to become a bridge between the mobile frontend and backend teams.

### Key Contributions

**1. Complete Patient Module (Weeks 1-8):**
- Designed and implemented the entire patient experience including dashboard, profile management, notification system, and games screens
- Developed patient authentication, email verification, and account management features
- Created the patient bottom navigation bar and routing system
- Implemented task completion and skip functionality allowing patients to manage their daily activities
- Built the patient settings screens including privacy, help & support features

**2. Guardian Module Development (Weeks 4-10):**
- Developed comprehensive guardian registration with full backend integration
- Implemented guardian dashboard showing all connected patients
- Created patient addition and management features including validation
- Built subscription plan selection and PayHere payment integration
- Developed patient details viewing and editing capabilities for guardians
- Implemented connection request system between guardians and patients

**3. Memory Match Game for Cognitive Training (Week 6):**
- Designed and developed a complete memory matching game for dementia patients
- Implemented game logic, timing, scoring, and difficulty levels
- Created smooth animations and engaging UI elements
- Fixed navigation flows to ensure seamless integration with the app

**4. Caregiver Features (Weeks 5-9):**
- Developed caregiver registration with password validation
- Fixed caregiver authentication and login flows
- Implemented caregiver article viewing features
- Built connection request handling between caregivers and patients

**5. Volunteer Module (Week 8):**
- Fixed volunteer screen navigation and UI issues
- Implemented volunteer acceptance workflow
- Enhanced volunteer profile and community features

**6. Appointment and Care Activity Management (Recent):**
- Developed appointment booking and management system
- Implemented care activity tracking and scheduling
- Created patient verification system for secure access
- Built guardian-patient connection approval flow

**7. System-Wide Contributions:**
- Established Firebase configuration and admin SDK integration
- Defined and maintained API constants and service layer architecture
- Implemented deep linking for email verification and password reset
- Fixed routing issues across all user types
- Developed color constants and theming system
- Created network debugging tools for testing
- Fixed numerous UI inconsistencies and bugs

### Collaboration and Communication

I actively participated in team meetings, code reviews, and pair programming sessions. I maintained clear documentation of my work and helped teammates understand the mobile codebase. When backend APIs were updated, I coordinated with backend developers to ensure smooth integration. I also mentored team members less familiar with Flutter, sharing knowledge about state management and widget composition.

### Challenges in Teamwork

Initially, we faced challenges with coordinating API contracts between frontend and backend. I learned to proactively communicate requirements and test endpoints early. There were also merge conflicts when multiple members worked on overlapping features, which taught me the importance of frequent commits and clear communication about working areas.

---

## 4. Reflections: Successes, Failures, and Future Improvements

### What Went Well

**Consistent Productivity:** My 56 commits with over 30,000 insertions demonstrate consistent contribution throughout the project lifecycle. I maintained momentum even during challenging periods.

**Feature Ownership:** Taking complete ownership of the patient module allowed me to deliver a cohesive, well-integrated experience. This end-to-end responsibility helped me understand the full development lifecycle.

**Problem-Solving Ability:** Many of my commits involved fixing complex issues—network errors, navigation problems, authentication bugs—showing my ability to debug and resolve real-world problems systematically.

**User-Centric Design:** Developing for dementia patients required careful consideration of accessibility and usability. I successfully created intuitive interfaces that cater to users with cognitive challenges.

**Integration Skills:** Successfully integrating multiple systems (Firebase, PayHere, backend APIs, deep linking) demonstrated my ability to work with diverse technologies and third-party services.

### What Went Wrong

**Initial Planning Gaps:** Early in the project, I sometimes started coding before fully understanding requirements, leading to rework. For example, some navigation patterns needed refactoring as new features were added.

**Over-Committing:** At times I took on too many tasks simultaneously, resulting in some features being implemented iteratively rather than comprehensively the first time. This is evident from multiple "fixed errors" commits showing I had to revisit code.

**Documentation Delays:** I sometimes postponed documenting complex features, making it harder for teammates to understand my implementations. Better inline documentation would have improved collaboration.

**Testing Gaps:** While I fixed many bugs, some issues could have been prevented with more systematic testing before commits. I relied too heavily on finding bugs during integration rather than preventing them earlier.

**Communication Timing:** Occasionally, I discovered API mismatches late in development because I didn't verify contracts early enough with backend developers.

### How I Will Improve

**1. Better Planning and Design:**
- Before coding, I will create detailed technical designs and get team feedback
- Use design patterns more deliberately from the start
- Break large features into smaller, testable increments with clear acceptance criteria

**2. Test-Driven Development:**
- Write unit tests before or alongside feature code
- Implement integration tests for critical user flows
- Adopt automated testing tools to catch regressions early

**3. Enhanced Documentation:**
- Document complex logic with inline comments as I code
- Create README files for major modules explaining architecture and usage
- Maintain a decision log for architectural choices

**4. Proactive Communication:**
- Establish API contracts with backend team before starting implementation
- Share progress updates more frequently in team channels
- Seek early feedback rather than presenting completed work

**5. Code Review Participation:**
- Request code reviews earlier and more frequently
- Review teammates' code more thoroughly to learn different approaches
- Use code reviews as learning opportunities for both sides

**6. Time Management:**
- Be more realistic about task estimation
- Focus on completing features thoroughly rather than starting many at once
- Build buffer time for testing and bug fixing in estimates

**7. Continuous Learning:**
- Stay updated with Flutter and mobile development best practices
- Learn advanced patterns like BLoC or Riverpod for state management
- Study software architecture principles more deeply

---

## Conclusion

This group project has been transformative in developing my technical abilities, professional skills, and self-awareness as a developer. The experience of building Memora—a real-world application addressing a genuine societal need—has been both challenging and rewarding. I contributed significantly to the mobile application's development, touching nearly every aspect of the patient, guardian, caregiver, and volunteer experiences.

More importantly, I learned valuable lessons about collaboration, planning, and continuous improvement. The mistakes I made and challenges I faced taught me as much as the successes. I am confident that the skills, experiences, and self-awareness gained through this project will serve as a strong foundation for my future career in software engineering.

The journey of working on Memora has prepared me not just to write code, but to think critically about user needs, collaborate effectively in teams, and deliver meaningful solutions that make a positive impact on people's lives.

---

**Word Count:** Approximately 1,950 words  
**Commitment:** This reflection represents my own work and experiences throughout the project.
