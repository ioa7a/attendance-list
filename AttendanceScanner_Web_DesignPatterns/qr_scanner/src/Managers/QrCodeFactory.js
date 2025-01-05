export class QrCodeFactory {
    constructor(courseName, qrCodeView) {
      this.courseName = courseName
      this.qrCodeView = qrCodeView
    }
  
    #qrCode;
    #finalAttendanceId;
  
    setQrCode(qrCode) {
      this.qrCode = qrCode;
    }
  
    getNewQrCodeId() {
      let date = new Date();
      let day = date.getDate();
      let month = date.getMonth() + 1;
      let year = date.getFullYear();
      let hour = date.getHours();
      let dateString = year + "_" + month + "_" + day + "_" + hour;
      this.finalAttendanceId = "id" + "_" + this.courseName.trim() + "_" + dateString;
    }
  
    generateQrCode() {
      if (this.qrCode == null) {
        this.qrCode = new QRCode(this.qrCodeView, this.finalAttendanceId);
      }
      else {
        this.qrCode.makeCode(this.finalAttendanceId);
      }
    }
  }