const API_BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:8080';

const articleApiService = {
  // Get ALL articles from all volunteers (all statuses: pending, published, rejected, draft)
  async getAllArticles() {
    try {
      console.log('Fetching ALL articles from volunteers (all statuses)...');
      
      const response = await fetch(`${API_BASE_URL}/api/articles/all`, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
        },
      });

      if (!response.ok) {
        throw new Error(`Failed to fetch articles: ${response.status}`);
      }

      const articles = await response.json();
      console.log(`Fetched ${articles.length} articles (all statuses)`);
      
      return articles;
    } catch (error) {
      console.error('Error fetching all articles:', error);
      throw error;
    }
  },

  // Get all published articles from all volunteers
  async getAllPublishedArticles() {
    try {
      console.log('Fetching all published articles from volunteers...');
      
      const response = await fetch(`${API_BASE_URL}/api/articles/published/all`, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
        },
      });

      if (!response.ok) {
        throw new Error(`Failed to fetch articles: ${response.status}`);
      }

      const articles = await response.json();
      console.log(`Fetched ${articles.length} published articles`);
      
      return articles;
    } catch (error) {
      console.error('Error fetching published articles:', error);
      throw error;
    }
  },

  // Get article detail by Firebase document ID
  async getArticleDetail(articleId) {
    try {
      console.log('Fetching article detail for ID:', articleId);
      
      const response = await fetch(`${API_BASE_URL}/api/articles/detail/${articleId}`, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
        },
      });

      if (!response.ok) {
        if (response.status === 404) {
          throw new Error('Article not found');
        }
        throw new Error(`Failed to fetch article detail: ${response.status}`);
      }

      const articleDetail = await response.json();
      console.log('Article detail fetched:', articleDetail.title);
      
      return articleDetail;
    } catch (error) {
      console.error('Error fetching article detail:', error);
      throw error;
    }
  },

  // Get articles by volunteer ID
  async getArticlesByVolunteer(volunteerId) {
    try {
      console.log('Fetching articles for volunteer ID:', volunteerId);
      
      const response = await fetch(`${API_BASE_URL}/api/articles/published?volunteerId=${volunteerId}`, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
        },
      });

      if (!response.ok) {
        throw new Error(`Failed to fetch volunteer articles: ${response.status}`);
      }

      const articles = await response.json();
      console.log(`Fetched ${articles.length} articles for volunteer ${volunteerId}`);
      
      return articles;
    } catch (error) {
      console.error('Error fetching volunteer articles:', error);
      throw error;
    }
  },

  // Get all article categories
  async getCategories() {
    try {
      console.log('Fetching article categories...');
      
      const response = await fetch(`${API_BASE_URL}/api/categories`, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
        },
      });

      if (!response.ok) {
        throw new Error(`Failed to fetch categories: ${response.status}`);
      }

      const categories = await response.json();
      console.log(`Fetched ${categories.length} categories`);
      
      return categories;
    } catch (error) {
      console.error('Error fetching categories:', error);
      throw error;
    }
  },

  // Get articles filtered by category
  async getArticlesByCategory(categoryId) {
    try {
      console.log('Fetching articles for category ID:', categoryId);
      
      // Get all published articles and filter by category on frontend
      // This is simpler than adding a new backend endpoint
      const allArticles = await this.getAllPublishedArticles();
      const filteredArticles = allArticles.filter(article => 
        article.categoryId === parseInt(categoryId)
      );
      
      console.log(`Filtered ${filteredArticles.length} articles for category ${categoryId}`);
      return filteredArticles;
    } catch (error) {
      console.error('Error fetching articles by category:', error);
      throw error;
    }
  },

  // Search articles by title or content
  async searchArticles(searchTerm) {
    try {
      console.log('Searching articles for term:', searchTerm);
      
      if (!searchTerm || searchTerm.trim() === '') {
        return await this.getAllPublishedArticles();
      }
      
      const allArticles = await this.getAllPublishedArticles();
      const searchTermLower = searchTerm.toLowerCase().trim();
      
      const filteredArticles = allArticles.filter(article => {
        const titleMatch = article.title && article.title.toLowerCase().includes(searchTermLower);
        const summaryMatch = article.summary && article.summary.toLowerCase().includes(searchTermLower);
        const authorMatch = article.authorName && article.authorName.toLowerCase().includes(searchTermLower);
        const categoryMatch = article.categoryName && article.categoryName.toLowerCase().includes(searchTermLower);
        
        return titleMatch || summaryMatch || authorMatch || categoryMatch;
      });
      
      console.log(`Found ${filteredArticles.length} articles matching "${searchTerm}"`);
      return filteredArticles;
    } catch (error) {
      console.error('Error searching articles:', error);
      throw error;
    }
  },

  // Format date for display
  formatDate(timestamp) {
    try {
      if (!timestamp) return 'Unknown';
      
      const date = new Date(timestamp);
      return date.toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'short',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
      });
    } catch (error) {
      console.error('Error formatting date:', error);
      return 'Invalid Date';
    }
  },

  // Generate excerpt from content
  generateExcerpt(content, maxLength = 150) {
    if (!content) return '';
    
    // Remove HTML tags if any
    const cleanContent = content.replace(/<[^>]*>/g, '');
    
    if (cleanContent.length <= maxLength) {
      return cleanContent;
    }
    
    // Find last complete sentence within limit
    const truncated = cleanContent.substring(0, maxLength);
    const lastPeriod = truncated.lastIndexOf('.');
    const lastSpace = truncated.lastIndexOf(' ');
    
    const cutoff = lastPeriod > maxLength * 0.7 ? lastPeriod + 1 : lastSpace;
    
    return cutoff > 0 ? truncated.substring(0, cutoff) + '...' : truncated + '...';
  },

  // Get placeholder image for articles without images
  getPlaceholderImage() {
    return 'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=400&h=200&fit=crop&auto=format';
  },

  // Validate image URL
  isValidImageUrl(url) {
    if (!url) return false;
    
    try {
      new URL(url);
      // Check if URL ends with common image extensions
      const imageExtensions = /\.(jpg|jpeg|png|gif|webp|svg)(\?.*)?$/i;
      return imageExtensions.test(url) || url.includes('unsplash.com') || url.includes('images');
    } catch {
      return false;
    }
  }
};

export default articleApiService;