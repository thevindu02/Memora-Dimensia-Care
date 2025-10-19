-- Check if there are any scheduled tasks for today
SELECT 
    ca.care_activity_id,
    s.date,
    ca.time,
    NOW() as current_time,
    (ca.time - INTERVAL '4 minutes') as reminder_time,
    COALESCE(dt.daily_task_name, g.name, m.medication_name, 'Unknown') as task_name,
    p.patient_id,
    u.f_name || ' ' || u.l_name as patient_name,
    CASE 
        WHEN ca.time > NOW() THEN 'FUTURE'
        ELSE 'PAST'
    END as status
FROM care_activities ca
JOIN schedules s ON ca.schedule_id = s.schedule_id
JOIN patients p ON s.patient_id = p.patient_id
JOIN users u ON p.user_id = u.user_id
LEFT JOIN daily_tasks dt ON dt.care_activity_id = ca.care_activity_id
LEFT JOIN tasks t ON t.care_activity_id = ca.care_activity_id
LEFT JOIN games g ON t.game_id = g.game_id
LEFT JOIN medication_reminders mr ON mr.care_activity_id = ca.care_activity_id
LEFT JOIN medications m ON mr.medication_id = m.medication_id
WHERE s.date = CURRENT_DATE
ORDER BY ca.time;
