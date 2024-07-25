import { fireEvent, render, waitFor } from "@testing-library/vue"
import { describe, expect, it, vi } from "vitest"
import { useToast } from "src/plugins/toast"
import { api } from "src/services"
import { createTestRouter, renderOptions } from "src/utils/test/test.utils"
import type {
  GenericErrorModel,
  HttpResponse,
  MessageResponse,
} from "../services/api"
import Register from "./Register.vue"

describe("# Register Page", () => {
  const router = createTestRouter()

  it("should render registration form", () => {
    const { getByPlaceholderText, getByRole } = render(
      Register,
      renderOptions({ router }),
    )

    expect(getByPlaceholderText("Your Name")).toBeInTheDocument()
    expect(getByPlaceholderText("Password")).toBeInTheDocument()
    expect(getByRole("button", { name: "Sign up" })).toBeInTheDocument()
  })

  it("should register successfully with valid credentials", async () => {
    vi.spyOn(api.users, "register").mockResolvedValueOnce({
      data: {
        message: "User created successfully",
      },
    } as HttpResponse<MessageResponse, GenericErrorModel>)

    const { getByPlaceholderText, getByRole } = render(
      Register,
      renderOptions({ router }),
    )
    const toastSuccessSpy = vi.spyOn(useToast(), "success")

    await fireEvent.update(getByPlaceholderText("Your Name"), "testuser")
    await fireEvent.update(getByPlaceholderText("Password"), "password123")
    await fireEvent.click(getByRole("button", { name: "Sign up" }))

    expect(api.users.register).toHaveBeenCalledWith({
      user: { username: "testuser", password: "password123" },
    })
    expect(toastSuccessSpy).not.toHaveBeenCalled()
    waitFor(() => {
      expect(toastSuccessSpy).toHaveBeenCalled()
      expect(router.currentRoute.value.path).toBe("/login")
    })
  })

  it("should display error message with invalid credentials", async () => {
    vi.spyOn(api.users, "register").mockRejectedValueOnce({
      error: {
        errors: {
          username: ["has already been taken"],
        },
      },
    })
    const toastErrorSpy = vi.spyOn(useToast(), "error")

    const { getByPlaceholderText, getByRole } = render(
      Register,
      renderOptions({ router }),
    )

    await fireEvent.update(getByPlaceholderText("Your Name"), "existinguser")
    await fireEvent.update(getByPlaceholderText("Password"), "password123")
    await fireEvent.click(getByRole("button", { name: "Sign up" }))

    waitFor(() =>
      expect(toastErrorSpy).toHaveBeenCalledWith(
        "username: has already been taken",
      ),
    )
  })
})
