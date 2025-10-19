import CONFIG from '../config/api.js';

class ArticleService {
  constructor() {
    this.baseURL = `${CONFIG.API_BASE_URL}/articles`;
    this.categoriesURL = `${CONFIG.API_BASE_URL}/categories`;
    this.imageUploadURL = `${CONFIG.API_BASE_URL}/upload/image`;
    this.imageValidateURL = `${CONFIG.API_BASE_URL}/images/validate-url`;
  }

  /**
   * Create a new article (blog post)
   * @param {Object} articleData - The article data
   * @param {string} articleData.title - Article title
   * @param {string} articleData.summary - Article summary
   * @param {string} articleData.content - Article content
   * @param {number} articleData.categoryId - Category ID
   * @param {number} articleData.volunteerId - Volunteer ID
   * @param {boolean} articleData.draft - Whether it's a draft
   * @param {string} articleData.articleImg - Article image URL (optional)
   * @returns {Promise<Object>} Response with success status and article data
   */
  async createArticle(articleData) {
    try {
      console.log('Creating article with data:', articleData);

      // Validate required fields
      if (!articleData.title || articleData.title.trim() === '') {
        throw new Error('Article title is required');
      }
      if (!articleData.content || articleData.content.trim() === '') {
        throw new Error('Article content is required');
      }
      if (!articleData.categoryId) {
        throw new Error('Article category is required');
      }
      if (!articleData.volunteerId) {
        throw new Error('Volunteer ID is required');
      }

      // Format the request body to match backend DTO
      const requestBody = {
        title: articleData.title.trim(),
        summary: articleData.summary?.trim() || '',
        content: articleData.content.trim(),
        categoryId: articleData.categoryId,
        volunteerId: articleData.volunteerId,
        draft: articleData.draft !== undefined ? articleData.draft : false,
        status: articleData.draft ? 'draft' : 'disapproved', // Default status for new articles
        articleImg: articleData.articleImg?.trim() || ''
      };

      const response = await fetch(this.baseURL, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(requestBody),
      });

      if (!response.ok) {
        let errorMessage = 'Failed to create article';
        
        if (response.status === 400) {
          // Bad request - likely validation error
          const errorText = await response.text();
          errorMessage = errorText || 'Invalid article data provided';
        } else if (response.status === 500) {
          errorMessage = 'Server error. Please try again later.';
        }
        
        throw new Error(errorMessage);
      }

      const result = await response.text(); // Backend returns string (update time)
      console.log('Article created successfully:', result);

      return {
        success: true,
        message: articleData.draft ? 'Draft saved successfully!' : 'Article submitted for review!',
        data: result
      };

    } catch (error) {
      console.error('Error creating article:', error);
      
      // Handle network errors
      if (error.name === 'TypeError' && error.message.includes('fetch')) {
        return {
          success: false,
          message: 'Network error. Please check your connection and try again.',
          error: error.message
        };
      }

      return {
        success: false,
        message: error.message || 'Failed to create article. Please try again.',
        error: error.message
      };
    }
  }

  /**
   * Get article by ID
   * @param {string} id - Article ID (Firebase document ID)
   * @returns {Promise<Object>} Response with article data
   */
  async getArticleById(id) {
    try {
      const response = await fetch(`${this.baseURL}/${id}`, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
        },
      });

      if (!response.ok) {
        if (response.status === 404) {
          throw new Error('Article not found');
        }
        throw new Error('Failed to fetch article');
      }

      const article = await response.json();
      return {
        success: true,
        data: article
      };

    } catch (error) {
      console.error('Error fetching article:', error);
      return {
        success: false,
        message: error.message || 'Failed to fetch article',
        error: error.message
      };
    }
  }

  /**
   * Get draft articles for a volunteer
   * @param {number} volunteerId - Volunteer ID
   * @returns {Promise<Object>} Response with draft articles
   */
  async getDraftArticles(volunteerId) {
    try {
      const response = await fetch(`${this.baseURL}/drafts?volunteerId=${volunteerId}`, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
        },
      });

      if (!response.ok) {
        throw new Error('Failed to fetch draft articles');
      }

      const drafts = await response.json();
      return {
        success: true,
        data: drafts
      };

    } catch (error) {
      console.error('Error fetching draft articles:', error);
      return {
        success: false,
        message: 'Failed to fetch draft articles',
        error: error.message
      };
    }
  }

  /**
   * Get published articles for a volunteer
   * @param {number} volunteerId - Volunteer ID
   * @returns {Promise<Object>} Response with published articles
   */
  async getPublishedArticles(volunteerId) {
    try {
      const response = await fetch(`${this.baseURL}/published?volunteerId=${volunteerId}`, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
        },
      });

      if (!response.ok) {
        throw new Error('Failed to fetch published articles');
      }

      const publishedArticles = await response.json();
      return {
        success: true,
        data: publishedArticles
      };

    } catch (error) {
      console.error('Error fetching published articles:', error);
      return {
        success: false,
        message: 'Failed to fetch published articles',
        error: error.message
      };
    }
  }

  /**
   * Get article detail with full content and metadata
   * @param {string} articleId - Article ID (Firebase document ID)
   * @returns {Promise<Object>} Response with complete article details
   */
  async getArticleDetail(articleId) {
    try {
      console.log('Fetching article detail for ID:', articleId);
      
      const response = await fetch(`${this.baseURL}/detail/${articleId}`, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
        },
      });

      if (!response.ok) {
        if (response.status === 404) {
          throw new Error('Article not found');
        }
        throw new Error('Failed to fetch article detail');
      }

      const articleDetail = await response.json();
      console.log('Article detail fetched:', articleDetail);
      
      return {
        success: true,
        data: articleDetail
      };

    } catch (error) {
      console.error('Error fetching article detail:', error);
      return {
        success: false,
        message: error.message || 'Failed to fetch article detail',
        error: error.message
      };
    }
  }

  /**
   * Update an existing article (draft or published)
   * @param {Object} articleData - The updated article data
   * @param {string} articleData.articleId - Firebase document ID
   * @param {string} articleData.title - Article title
   * @param {string} articleData.summary - Article summary
   * @param {string} articleData.content - Article content
   * @param {number} articleData.categoryId - Category ID
   * @param {number} articleData.volunteerId - Volunteer ID
   * @param {boolean} articleData.draft - Whether it's a draft
   * @param {string} articleData.articleImg - Article image URL (optional)
   * @returns {Promise<Object>} Response with success status
   */
  async updateArticle(articleData) {
    try {
      console.log('Updating article with data:', articleData);

      // Validate required fields
      if (!articleData.articleId) {
        throw new Error('Article ID is required');
      }
      if (!articleData.title || articleData.title.trim() === '') {
        throw new Error('Article title is required');
      }
      if (!articleData.content || articleData.content.trim() === '') {
        throw new Error('Article content is required');
      }
      if (!articleData.categoryId) {
        throw new Error('Article category is required');
      }
      if (!articleData.volunteerId) {
        throw new Error('Volunteer ID is required');
      }

      // Format the request body
      const requestBody = {
        articleId: articleData.articleId,
        title: articleData.title.trim(),
        summary: articleData.summary?.trim() || '',
        content: articleData.content.trim(),
        categoryId: articleData.categoryId,
        volunteerId: articleData.volunteerId,
        draft: articleData.draft !== undefined ? articleData.draft : false,
        status: articleData.draft ? 'draft' : 'disapproved', // Reset status for non-drafts
        articleImg: articleData.articleImg?.trim() || ''
      };

      const response = await fetch(`${this.baseURL}/${articleData.articleId}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(requestBody),
      });

      if (!response.ok) {
        let errorMessage = 'Failed to update article';
        
        if (response.status === 400) {
          const errorText = await response.text();
          errorMessage = errorText || 'Invalid article data provided';
        } else if (response.status === 404) {
          errorMessage = 'Article not found';
        } else if (response.status === 500) {
          errorMessage = 'Server error. Please try again later.';
        }
        
        throw new Error(errorMessage);
      }

      const result = await response.text();
      console.log('Article updated successfully:', result);

      return {
        success: true,
        message: articleData.draft ? 'Draft updated successfully!' : 'Article updated and submitted for review!',
        data: result
      };

    } catch (error) {
      console.error('Error updating article:', error);
      
      if (error.name === 'TypeError' && error.message.includes('fetch')) {
        return {
          success: false,
          message: 'Network error. Please check your connection and try again.',
          error: error.message
        };
      }

      return {
        success: false,
        message: error.message || 'Failed to update article. Please try again.',
        error: error.message
      };
    }
  }

  /**
   * Upload an image file
   * @param {File} file - The image file to upload
   * @param {string} type - The type of image (header, content, etc.)
   * @returns {Promise<Object>} Response with image URL
   */
  async uploadImage(file, type = 'content') {
    try {
      // Validate file
      if (!file) {
        throw new Error('No file selected');
      }

      if (!file.type.startsWith('image/')) {
        throw new Error('Please select a valid image file');
      }

      if (file.size > 5 * 1024 * 1024) { // 5MB limit
        throw new Error('Image size should be less than 5MB');
      }

      // Create FormData
      const formData = new FormData();
      formData.append('image', file);
      formData.append('type', type);

      const response = await fetch(this.imageUploadURL, {
        method: 'POST',
        body: formData, // Don't set Content-Type header - let browser set it
      });

      if (!response.ok) {
        let errorMessage = 'Failed to upload image';
        try {
          const errorData = await response.json();
          errorMessage = errorData.message || errorMessage;
        } catch (e) {
          // If can't parse JSON, use default message
        }
        throw new Error(errorMessage);
      }

      const result = await response.json();
      console.log('Image uploaded successfully:', result);

      return {
        success: true,
        message: 'Image uploaded successfully!',
        imageUrl: result.imageUrl,
        fileName: result.fileName,
        fileSize: result.fileSize
      };

    } catch (error) {
      console.error('Error uploading image:', error);
      return {
        success: false,
        message: error.message || 'Failed to upload image',
        error: error.message
      };
    }
  }

  /**
   * Validate an image URL
   * @param {string} url - The image URL to validate
   * @returns {Promise<Object>} Response with validation result
   */
  async validateImageUrl(url) {
    try {
      if (!url || url.trim() === '') {
        throw new Error('Image URL is required');
      }

      const response = await fetch(this.imageValidateURL, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ url: url.trim() }),
      });

      if (!response.ok) {
        throw new Error('Failed to validate image URL');
      }

      const result = await response.json();
      console.log('URL validation result:', result);

      return {
        success: result.success,
        valid: result.valid,
        message: result.message,
        url: result.url
      };

    } catch (error) {
      console.error('Error validating image URL:', error);
      return {
        success: false,
        valid: false,
        message: error.message || 'Failed to validate image URL',
        error: error.message
      };
    }
  }

  /**
   * Get all article categories
   * @returns {Promise<Object>} Response with categories
   */
  async getCategories() {
    try {
      const response = await fetch(this.categoriesURL, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
        },
      });

      if (!response.ok) {
        throw new Error('Failed to fetch categories');
      }

      const categories = await response.json();
      return {
        success: true,
        data: categories
      };

    } catch (error) {
      console.error('Error fetching categories:', error);
      return {
        success: false,
        message: 'Failed to fetch categories',
        error: error.message
      };
    }
  }

  /**
   * Validate article data before sending to API
   * @param {Object} articleData - Article data to validate
   * @returns {Object} Validation result with isValid flag and errors array
   */
  validateArticleData(articleData) {
    const errors = [];

    // Validate title
    if (!articleData.title || articleData.title.trim() === '') {
      errors.push('Article title is required');
    } else if (articleData.title.trim().length < 5) {
      errors.push('Article title must be at least 5 characters long');
    } else if (articleData.title.trim().length > 200) {
      errors.push('Article title must be less than 200 characters');
    }

    // Validate content
    if (!articleData.content || articleData.content.trim() === '') {
      errors.push('Article content is required');
    } else if (articleData.content.trim().length < 50) {
      errors.push('Article content must be at least 50 characters long');
    }

    // Validate category
    if (!articleData.categoryId) {
      errors.push('Please select a category');
    }

    // Validate summary if provided
    if (articleData.summary && articleData.summary.trim().length > 500) {
      errors.push('Summary must be less than 500 characters');
    }

    // Validate volunteer ID
    if (!articleData.volunteerId) {
      errors.push('Volunteer information is missing');
    }

    return {
      isValid: errors.length === 0,
      errors
    };
  }

  /**
   * Generate a summary from content if not provided
   * @param {string} content - Article content
   * @param {number} maxLength - Maximum summary length
   * @returns {string} Generated summary
   */
  generateSummary(content, maxLength = 200) {
    if (!content || typeof content !== 'string') {
      return '';
    }

    // Remove HTML tags if any
    const cleanContent = content.replace(/<[^>]*>/g, '');
    
    // Take first few sentences up to maxLength
    const sentences = cleanContent.split(/[.!?]+/);
    let summary = '';
    
    for (const sentence of sentences) {
      const trimmedSentence = sentence.trim();
      if (trimmedSentence && (summary + trimmedSentence).length <= maxLength) {
        summary += (summary ? '. ' : '') + trimmedSentence;
      } else {
        break;
      }
    }
    
    // If still empty, take first maxLength characters
    if (!summary && cleanContent.length > 0) {
      summary = cleanContent.substring(0, maxLength).trim();
      // Don't cut words in the middle
      const lastSpace = summary.lastIndexOf(' ');
      if (lastSpace > maxLength * 0.8) {
        summary = summary.substring(0, lastSpace);
      }
      summary += '...';
    }
    
    return summary;
  }

  /**
   * Clean and format content (remove dangerous HTML, format properly)
   * @param {string} content - Raw content
   * @returns {string} Cleaned content
   */
  cleanContent(content) {
    if (!content || typeof content !== 'string') {
      return '';
    }

    // For now, just trim and return
    // In a real app, you might want to sanitize HTML content
    return content.trim();
  }
}

// Create and export a singleton instance
const articleService = new ArticleService();
export default articleService;
