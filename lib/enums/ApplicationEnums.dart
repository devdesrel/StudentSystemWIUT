enum AuthState { LOGGED_IN, LOGGED_OUT, SHOW_PREVIEW_PAGE }

enum MainPageGridItems {
  MARKS,
  TIMETABLE,
  LEARNING_MATERIALS,
  OFFENCES,
  COURSEWORK_UPLOAD,
  PAYMENT,
  BOOK_ORDERING,
  SOCIAL,
  CCMFEEDBACK
}

enum MessageTypes { ERROR, INFO, SUCCESS, INFINITE_INFO }

enum TimetableDropdownlinListType { Group, Room, Teacher }
enum ChangePinCodeDialogArguments { CurrentPin, NewPin, ConfirmPin }

enum RequestType { GetMarks, GetTeachingMaterials }
enum IosPinRequestType { SetPin, ChangePin }

enum AttachmentTypes { CAMERA, GALLERY, QUESTIONNAIRE, FILE, STICKER }

enum ExpansionTileTypes { TeacherName, FeedbackType }
enum FeedbackViewType { Add, Edit }
enum CCMFeedbackCategory { ModulesFeedback, DepartmentsFeedback }
