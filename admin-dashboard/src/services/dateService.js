// Sample data with dates for demonstration
const articlesData = [
  { id: 1, title: 'Understanding Dementia: A Guide for Sri Lankan Families', author: 'Dr. Priya Jayawardena', category: 'Medical', status: 'Published', publishDate: '2025-07-19', type: 'article' },
  { id: 2, title: 'Traditional Ayurvedic Approaches to Memory Care', author: 'Prof. Sunil Rathnayake', category: 'Traditional Medicine', status: 'Pending', publishDate: '2025-07-19', type: 'article' },
  { id: 3, title: 'Nutrition for Brain Health: Sri Lankan Superfoods', author: 'Nutritionist Kamala Silva', category: 'Nutrition', status: 'Published', publishDate: '2025-07-18', type: 'article' },
  { id: 4, title: 'Creating a Safe Home Environment for Dementia Patients', author: 'Arch. Nimal Perera', category: 'Home Care', status: 'Published', publishDate: '2025-07-17', type: 'article' },
  { id: 5, title: 'Community Support Systems in Rural Sri Lanka', author: 'Social Worker Sanduni Fernando', category: 'Community', status: 'Draft', publishDate: '2025-07-16', type: 'article' },
  { id: 6, title: 'Technology Solutions for Memory Care', author: 'Tech Specialist Ruwan Bandara', category: 'Technology', status: 'Published', publishDate: '2025-07-15', type: 'article' },
  { id: 7, title: 'Managing Behavioral Changes in Dementia', author: 'Dr. Anura Wickramasinghe', category: 'Psychology', status: 'Rejected', publishDate: '2025-07-14', type: 'article' },
  { id: 8, title: 'Exercise and Physical Activity for Memory Health', author: 'Physiotherapist Malini Dissanayake', category: 'Exercise', status: 'Published', publishDate: '2025-07-13', type: 'article' }
];

const blogPostsData = [
  { id: 1, title: 'Understanding Alzheimer\'s Disease', subject: 'Health Education', postedBy: 'Dr. Sarah Johnson', date: '2025-07-19', status: 'Pending', type: 'blog' },
  { id: 2, title: 'Managing Dementia Symptoms', subject: 'Care Tips', postedBy: 'Nurse Mary Davis', date: '2025-07-19', status: 'Pending', type: 'blog' },
  { id: 3, title: 'Family Support Guide', subject: 'Family Care', postedBy: 'Dr. Michael Wilson', date: '2025-07-18', status: 'Posted', type: 'blog' },
  { id: 4, title: 'Memory Exercises for Seniors', subject: 'Activities', postedBy: 'Therapist Lisa Brown', date: '2025-07-17', status: 'Posted', type: 'blog' },
  { id: 5, title: 'Nutrition for Brain Health', subject: 'Health Education', postedBy: 'Dr. James Miller', date: '2025-07-16', status: 'Rejected', type: 'blog' },
  { id: 6, title: 'Early Signs of Dementia', subject: 'Health Education', postedBy: 'Dr. Sarah Johnson', date: '2025-07-15', status: 'Posted', type: 'blog' },
  { id: 7, title: 'Caregiver Stress Management', subject: 'Care Tips', postedBy: 'Counselor Anna Lee', date: '2025-07-14', status: 'Pending', type: 'blog' },
  { id: 8, title: 'Safe Home Environment', subject: 'Safety', postedBy: 'Dr. Robert Taylor', date: '2025-07-13', status: 'Posted', type: 'blog' }
];

const patientsData = [
  { id: 1, name: 'John Doe', age: 72, registeredDate: '2025-07-19', type: 'patient' },
  { id: 2, name: 'Jane Smith', age: 68, registeredDate: '2025-07-18', type: 'patient' },
  { id: 3, name: 'Robert Johnson', age: 75, registeredDate: '2025-07-17', type: 'patient' },
  { id: 4, name: 'Mary Wilson', age: 70, registeredDate: '2025-07-16', type: 'patient' },
  { id: 5, name: 'David Brown', age: 73, registeredDate: '2025-07-15', type: 'patient' },
  { id: 6, name: 'Susan Davis', age: 69, registeredDate: '2025-07-14', type: 'patient' },
  { id: 7, name: 'Michael Miller', age: 71, registeredDate: '2025-07-13', type: 'patient' },
  { id: 8, name: 'Lisa Anderson', age: 67, registeredDate: '2025-07-12', type: 'patient' }
];

const volunteersData = [
  { id: 1, name: 'Alice Cooper', joinDate: '2025-07-19', type: 'volunteer' },
  { id: 2, name: 'Bob Wilson', joinDate: '2025-07-18', type: 'volunteer' },
  { id: 3, name: 'Carol Davis', joinDate: '2025-07-17', type: 'volunteer' },
  { id: 4, name: 'Daniel Garcia', joinDate: '2025-07-16', type: 'volunteer' },
  { id: 5, name: 'Eva Martinez', joinDate: '2025-07-15', type: 'volunteer' }
];

const caregiversData = [
  { id: 1, name: 'Dr. Emily Johnson', joinDate: '2025-07-19', type: 'caregiver' },
  { id: 2, name: 'Nurse Sarah Williams', joinDate: '2025-07-18', type: 'caregiver' }
];

// Simulated video data
const videosData = [
  { id: 1, title: 'Memory Care Basics', uploadDate: '2025-07-19', type: 'video' },
  { id: 2, title: 'Family Support Techniques', uploadDate: '2025-07-18', type: 'video' },
  { id: 3, title: 'Daily Exercise Routines', uploadDate: '2025-07-17', type: 'video' },
  { id: 4, title: 'Nutrition Guidelines', uploadDate: '2025-07-16', type: 'video' },
  { id: 5, title: 'Communication Tips', uploadDate: '2025-07-15', type: 'video' },
  { id: 6, title: 'Home Safety Measures', uploadDate: '2025-07-14', type: 'video' },
  { id: 7, title: 'Medication Management', uploadDate: '2025-07-13', type: 'video' },
  { id: 8, title: 'Stress Relief Techniques', uploadDate: '2025-07-12', type: 'video' }
];

export const getDateBasedStats = (selectedDate) => {
  const dateString = selectedDate.toISOString().split('T')[0]; // Format: YYYY-MM-DD
  
  // Count items for the selected date
  const patientsCount = patientsData.filter(patient => patient.registeredDate === dateString).length;
  const caregiversCount = caregiversData.filter(caregiver => caregiver.joinDate === dateString).length;
  const volunteersCount = volunteersData.filter(volunteer => volunteer.joinDate === dateString).length;
  const blogPostsCount = blogPostsData.filter(blog => blog.date === dateString).length;
  const articlesCount = articlesData.filter(article => article.publishDate === dateString).length;
  const videosCount = videosData.filter(video => video.uploadDate === dateString).length;

  return [
    { number: patientsCount, label: 'New Patients', icon: '👥' },
    { number: caregiversCount, label: 'New Caregivers', icon: '👩‍⚕️' },
    { number: volunteersCount, label: 'New Volunteers', icon: '🤝' },
    { number: blogPostsCount, label: 'Blog Posts', icon: '📝' },
    { number: articlesCount, label: 'Articles', icon: '📄' },
    { number: videosCount, label: 'Videos', icon: '🎬' }
  ];
};

export const getTotalStats = () => {
  return [
    { number: patientsData.length, label: 'Total Patients', icon: '👥' },
    { number: caregiversData.length, label: 'Total Caregivers', icon: '👩‍⚕️' },
    { number: volunteersData.length, label: 'Total Volunteers', icon: '🤝' },
    { number: blogPostsData.length, label: 'Total Blog Posts', icon: '📝' },
    { number: articlesData.length, label: 'Total Articles', icon: '📄' },
    { number: videosData.length, label: 'Total Videos', icon: '🎬' }
  ];
};

export const getActivitiesForDate = (selectedDate) => {
  const dateString = selectedDate.toISOString().split('T')[0];
  
  const activities = [];
  
  // Add activities for the selected date
  patientsData.forEach(patient => {
    if (patient.registeredDate === dateString) {
      activities.push({
        type: 'patient_registered',
        title: `New patient registered: ${patient.name}`,
        time: '09:00 AM'
      });
    }
  });
  
  caregiversData.forEach(caregiver => {
    if (caregiver.joinDate === dateString) {
      activities.push({
        type: 'caregiver_joined',
        title: `New caregiver joined: ${caregiver.name}`,
        time: '10:30 AM'
      });
    }
  });
  
  volunteersData.forEach(volunteer => {
    if (volunteer.joinDate === dateString) {
      activities.push({
        type: 'volunteer_joined',
        title: `New volunteer joined: ${volunteer.name}`,
        time: '11:45 AM'
      });
    }
  });
  
  articlesData.forEach(article => {
    if (article.publishDate === dateString) {
      activities.push({
        type: 'article_published',
        title: `Article published: ${article.title}`,
        time: '02:15 PM'
      });
    }
  });
  
  blogPostsData.forEach(blog => {
    if (blog.date === dateString) {
      activities.push({
        type: 'blog_posted',
        title: `Blog post created: ${blog.title}`,
        time: '03:30 PM'
      });
    }
  });
  
  videosData.forEach(video => {
    if (video.uploadDate === dateString) {
      activities.push({
        type: 'video_uploaded',
        title: `Video uploaded: ${video.title}`,
        time: '04:00 PM'
      });
    }
  });
  
  return activities.sort((a, b) => a.time.localeCompare(b.time));
};
