import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:host_app/main.dart';
import 'package:host_app/presentation/controllers/property_form_controller.dart';
import 'package:host_app/presentation/controllers/chat_controller.dart';
import 'package:host_app/data/models/property_model.dart';
import 'package:host_app/domain/entities/property.dart';

void main() {
  group('PropertyFormController Tests', () {
    late PropertyFormController controller;

    setUp(() {
      controller = PropertyFormController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Initial state should be correct', () {
      expect(controller.currentStep.value, equals(0));
      expect(controller.propertyType.value, isEmpty);
      expect(controller.title.value, isEmpty);
      expect(controller.rooms.value, equals(1));
      expect(controller.description.value, isEmpty);
      expect(controller.price.value, equals(0.0));
      expect(controller.amenities, isEmpty);
    });

    test('nextStep should increment current step', () {
      controller.nextStep();
      expect(controller.currentStep.value, equals(1));

      controller.nextStep();
      expect(controller.currentStep.value, equals(2));

      controller.nextStep();
      expect(controller.currentStep.value, equals(3));

      controller.nextStep();
      expect(controller.currentStep.value, equals(4));
    });

    test('nextStep should not go beyond step 4', () {
      controller.currentStep.value = 4;
      controller.nextStep();
      expect(controller.currentStep.value, equals(4));
    });

    test('previousStep should decrement current step', () {
      controller.currentStep.value = 3;
      controller.previousStep();
      expect(controller.currentStep.value, equals(2));

      controller.previousStep();
      expect(controller.currentStep.value, equals(1));

      controller.previousStep();
      expect(controller.currentStep.value, equals(0));
    });

    test('previousStep should not go below 0', () {
      controller.currentStep.value = 0;
      controller.previousStep();
      expect(controller.currentStep.value, equals(0));
    });

    test('handleAutofill should update all fields', () {
      final fillData = {
        'title': 'Luxury Apartment',
        'description': 'Beautiful penthouse',
        'rooms': 5,
        'type': 'apartment',
        'amenities': ['WiFi', 'Pool', 'Gym'],
      };

      controller.handleAutofill(fillData);

      expect(controller.title.value, equals('Luxury Apartment'));
      expect(controller.description.value, equals('Beautiful penthouse'));
      expect(controller.rooms.value, equals(5));
      expect(controller.propertyType.value, equals('apartment'));
      expect(controller.amenities, equals(['WiFi', 'Pool', 'Gym']));
    });

    test('handleAutofill should handle partial data', () {
      final fillData = {'title': 'Beach House', 'rooms': 3};

      controller.handleAutofill(fillData);

      expect(controller.title.value, equals('Beach House'));
      expect(controller.rooms.value, equals(3));
      expect(controller.description.value, isEmpty);
    });

    test('handleAutofill should update text controllers', () {
      final fillData = {
        'title': 'Modern Villa',
        'description': 'Stunning ocean view',
      };

      controller.handleAutofill(fillData);

      expect(controller.titleController.text, equals('Modern Villa'));
      expect(
        controller.descriptionController.text,
        equals('Stunning ocean view'),
      );
    });
  });

  group('ChatController Tests', () {
    late ChatController controller;

    setUp(() {
      controller = ChatController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Initial state should be correct', () {
      expect(controller.isPanelOpen.value, isFalse);
      expect(controller.isTyping.value, isFalse);
      expect(controller.messages, isEmpty);
      expect(controller.currentScreenContext.value, equals('home'));
      expect(controller.currentFormData, isEmpty);
    });

    test('toggleChatPanel should toggle panel state', () {
      expect(controller.isPanelOpen.value, isFalse);

      controller.toggleChatPanel();
      expect(controller.isPanelOpen.value, isTrue);

      controller.toggleChatPanel();
      expect(controller.isPanelOpen.value, isFalse);
    });

    test('toggleChatPanel should add welcome message on first open', () {
      controller.toggleChatPanel();
      expect(controller.messages.length, equals(1));
      expect(controller.messages[0].isUser, isFalse);
      expect(
        controller.messages[0].text.contains("I'm your AI assistant"),
        isTrue,
      );
    });

    test('updateContext should update screen context and form data', () {
      const screenName = 'property_form';
      final formData = {
        'title': 'Test Property',
        'type': 'apartment',
        'rooms': 3,
      };

      controller.updateContext(screenName, formData);

      expect(controller.currentScreenContext.value, equals(screenName));
      expect(controller.currentFormData, equals(formData));
    });

    test('ChatMessage should be created correctly', () {
      final message = ChatMessage(text: 'Hello', isUser: true);

      expect(message.text, equals('Hello'));
      expect(message.isUser, isTrue);
    });

    test('messages list should store multiple messages', () {
      controller.messages.add(ChatMessage(text: 'Hello', isUser: true));
      controller.messages.add(ChatMessage(text: 'Hi there', isUser: false));
      controller.messages.add(ChatMessage(text: 'How are you?', isUser: true));

      expect(controller.messages.length, equals(3));
      expect(controller.messages[0].isUser, isTrue);
      expect(controller.messages[1].isUser, isFalse);
      expect(controller.messages[2].isUser, isTrue);
    });
  });

  group('PropertyModel Tests', () {
    test('PropertyModel should be created correctly', () {
      final property = PropertyModel(
        id: '1',
        title: 'Beach House',
        type: 'house',
        rooms: 4,
        price: 250000.0,
        amenities: ['WiFi', 'Pool'],
        description: 'Beautiful beach property',
      );

      expect(property.id, equals('1'));
      expect(property.title, equals('Beach House'));
      expect(property.type, equals('house'));
      expect(property.rooms, equals(4));
      expect(property.price, equals(250000.0));
      expect(property.amenities, equals(['WiFi', 'Pool']));
      expect(property.description, equals('Beautiful beach property'));
    });

    test('PropertyModel.fromJson should parse JSON correctly', () {
      final json = {
        'id': '123',
        'title': 'Modern Apartment',
        'type': 'apartment',
        'rooms': 3,
        'price': 150000,
        'amenities': ['Gym', 'Parking'],
        'description': 'Modern city apartment',
      };

      final property = PropertyModel.fromJson(json);

      expect(property.id, equals('123'));
      expect(property.title, equals('Modern Apartment'));
      expect(property.type, equals('apartment'));
      expect(property.rooms, equals(3));
      expect(property.price, equals(150000.0));
      expect(property.amenities, equals(['Gym', 'Parking']));
      expect(property.description, equals('Modern city apartment'));
    });

    test('PropertyModel.toJson should convert to JSON correctly', () {
      final property = PropertyModel(
        id: '456',
        title: 'Luxury Villa',
        type: 'villa',
        rooms: 6,
        price: 500000.0,
        amenities: ['Pool', 'Garden', 'Sauna'],
        description: 'Luxury property',
      );

      final json = property.toJson();

      expect(json['id'], equals('456'));
      expect(json['title'], equals('Luxury Villa'));
      expect(json['type'], equals('villa'));
      expect(json['rooms'], equals(6));
      expect(json['price'], equals(500000.0));
      expect(json['amenities'], equals(['Pool', 'Garden', 'Sauna']));
      expect(json['description'], equals('Luxury property'));
    });

    test('PropertyModel should handle price conversion from int', () {
      final json = {
        'id': '789',
        'title': 'Cozy Studio',
        'type': 'studio',
        'rooms': 1,
        'price': 50000, // integer
        'amenities': ['WiFi'],
        'description': 'Small studio',
      };

      final property = PropertyModel.fromJson(json);
      expect(property.price, isA<double>());
      expect(property.price, equals(50000.0));
    });
  });

  group('Property Entity Tests', () {
    test('Property should be created correctly', () {
      final property = Property(
        id: 'prop1',
        title: 'Test Property',
        type: 'apartment',
        rooms: 2,
        price: 100000.0,
        amenities: ['WiFi'],
        description: 'Test description',
      );

      expect(property.id, equals('prop1'));
      expect(property.title, equals('Test Property'));
      expect(property.type, equals('apartment'));
      expect(property.rooms, equals(2));
      expect(property.price, equals(100000.0));
      expect(property.amenities, equals(['WiFi']));
      expect(property.description, equals('Test description'));
    });
  });

  group('Widget Tests', () {
    testWidgets('HostApp should render without errors', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const HostApp());
      expect(find.byType(GetMaterialApp), findsOneWidget);
    });

    testWidgets('HostApp should have GetMaterialApp widget', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const HostApp());
      expect(find.byType(GetMaterialApp), findsWidgets);
    });
  });
}
