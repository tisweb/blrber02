// Model for Company Detail table

class CompanyDetail {
  String companyName;
  String email;
  String webSite;
  String address1;
  String address2;
  String countryCode;
  String primaryContactNumber;
  String customerCareNumber;
  String logoImageUrl;
  String companyDetailsDocId;

  CompanyDetail({
    this.companyName,
    this.email,
    this.webSite,
    this.address1,
    this.address2,
    this.countryCode,
    this.primaryContactNumber,
    this.customerCareNumber,
    this.logoImageUrl,
    this.companyDetailsDocId,
  });
}
