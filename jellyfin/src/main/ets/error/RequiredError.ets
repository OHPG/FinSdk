import { ApiError } from "../network/ApiError";

export class RequiredError extends ApiError {
  constructor(message: string) {
    super(403, message)
  }

}