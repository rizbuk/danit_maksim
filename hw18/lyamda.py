import json
import boto3

## Ініціалізуємо клієнт для роботи з EC2
ec2 = boto3.client('ec2')

def lambda_handler(event, context):
    # Налаштування тегу для пошуку
    TAG_KEY = 'Environment'
    TAG_VALUE = 'Development'
    
    try:
        # Шукаємо тільки запущені (running) інстанси з конкретним тегом
        filters = [
            {'Name': f'tag:{TAG_KEY}', 'Values': [TAG_VALUE]},
            {'Name': 'instance-state-name', 'Values': ['running']}
        ]
        
        # Отримуємо список інстансів
        response = ec2.describe_instances(Filters=filters)
        
        instance_ids = []
        for reservation in response['Reservations']:
            for instance in reservation['Instances']:
                instance_ids.append(instance['InstanceId'])
        
        # Якщо знайшли інстанси — зупиняємо їх
        if instance_ids:
            print(f"Знайдено інстанси для зупинки: {instance_ids}")
            ec2.stop_instances(InstanceIds=instance_ids)
            message = f"Успішно зупинено інстанси: {instance_ids}"
        else:
            message = "Запущених інстансів із таким тегом не знайдено."
            print(message)
            
        return {
            'statusCode': 200,
            'body': json.dumps(message)
        }
        
    except Exception as e:
        print(f"Помилка: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps(f"Сталася помилка: {str(e)}")
        }
