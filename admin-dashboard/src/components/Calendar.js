import React, { useState } from 'react';

const Calendar = () => {
  const [selectedDate, setSelectedDate] = useState(new Date(2025, 7, 17)); // August 17, 2025

  const getDaysInMonth = (date) => {
    const year = date.getFullYear();
    const month = date.getMonth();
    const firstDay = new Date(year, month, 1);
    const lastDay = new Date(year, month + 1, 0);
    const daysInMonth = lastDay.getDate();
    const startingDayOfWeek = firstDay.getDay();

    const days = [];
    
    // Add empty cells for days before the first day of the month
    for (let i = 0; i < startingDayOfWeek; i++) {
      days.push(null);
    }
    
    // Add days of the month
    for (let day = 1; day <= daysInMonth; day++) {
      days.push(day);
    }
    
    return days;
  };

  const days = getDaysInMonth(selectedDate);
  const monthYear = selectedDate.toLocaleDateString('en-US', { month: 'long', year: 'numeric' });
  const currentDay = selectedDate.getDate();
  
  return (
    <div className="calendar-container">
      <div className="calendar-header">
        <button onClick={() => setSelectedDate(new Date(selectedDate.getFullYear(), selectedDate.getMonth() - 1, selectedDate.getDate()))}>
          &#8249;
        </button>
        <span>{monthYear}</span>
        <button onClick={() => setSelectedDate(new Date(selectedDate.getFullYear(), selectedDate.getMonth() + 1, selectedDate.getDate()))}>
          &#8250;
        </button>
      </div>
      <div className="calendar-grid">
        <div className="calendar-weekdays">
          {['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day, index) => (
            <div key={index} className="weekday">{day}</div>
          ))}
        </div>
        <div className="calendar-days">
          {days.map((day, index) => (
            <div 
              key={index} 
              className={`calendar-day ${day === currentDay ? 'selected' : ''} ${day ? 'has-day' : ''}`}
              onClick={() => day && setSelectedDate(new Date(selectedDate.getFullYear(), selectedDate.getMonth(), day))}
            >
              {day}
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default Calendar;
